Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AA049E9BC
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbiA0SJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244856AbiA0SJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DF4FB820C9;
        Thu, 27 Jan 2022 18:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6438C340E4;
        Thu, 27 Jan 2022 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306946;
        bh=4UsuwMhNkK3Dc4juRp0J3jVJf5ebgUWC6e2tsEAOhjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtRi+X1ajOgzxYp2N16LzzLh9fLHxIObvSq5ypQdDV9H8gMPtA+XeVwlnknah/S6v
         tO68yqqgpiqwP2433RqFmCv9YPIfeNH319Zx6AoR1epFWuBnGl+Nu/RwNRVG057Ty3
         lA0Sj/5Qb7DLBodczGrZ5kpKO05tFO0RWJpeWl8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>
Subject: [PATCH 4.9 8/9] ion: Protect kref from userspace manipulation
Date:   Thu, 27 Jan 2022 19:08:26 +0100
Message-Id: <20220127180257.487800017@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
References: <20220127180257.225641300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Rosenberg <drosen@google.com>

This separates the kref for ion handles into two components.
Userspace requests through the ioctl will hold at most one
reference to the internally used kref. All additional requests
will increment a separate counter, and the original reference is
only put once that counter hits 0. This protects the kernel from
a poorly behaving userspace.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
[d-cagle@codeaurora.org: Resolve style issues]
Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/android/ion/ion-ioctl.c |   84 +++++++++++++++++++++++++++++---
 drivers/staging/android/ion/ion.c       |    4 -
 drivers/staging/android/ion/ion_priv.h  |    4 +
 3 files changed, 83 insertions(+), 9 deletions(-)

--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -30,6 +30,69 @@ union ion_ioctl_arg {
 	struct ion_heap_query query;
 };
 
+/* Must hold the client lock */
+static void user_ion_handle_get(struct ion_handle *handle)
+{
+	if (handle->user_ref_count++ == 0)
+		kref_get(&handle->ref);
+}
+
+/* Must hold the client lock */
+static struct ion_handle *user_ion_handle_get_check_overflow(
+	struct ion_handle *handle)
+{
+	if (handle->user_ref_count + 1 == 0)
+		return ERR_PTR(-EOVERFLOW);
+	user_ion_handle_get(handle);
+	return handle;
+}
+
+/* passes a kref to the user ref count.
+ * We know we're holding a kref to the object before and
+ * after this call, so no need to reverify handle.
+ */
+static struct ion_handle *pass_to_user(struct ion_handle *handle)
+{
+	struct ion_client *client = handle->client;
+	struct ion_handle *ret;
+
+	mutex_lock(&client->lock);
+	ret = user_ion_handle_get_check_overflow(handle);
+	ion_handle_put_nolock(handle);
+	mutex_unlock(&client->lock);
+	return ret;
+}
+
+/* Must hold the client lock */
+static int user_ion_handle_put_nolock(struct ion_handle *handle)
+{
+	int ret;
+
+	if (--handle->user_ref_count == 0)
+		ret = ion_handle_put_nolock(handle);
+
+	return ret;
+}
+
+static void user_ion_free_nolock(struct ion_client *client,
+				 struct ion_handle *handle)
+{
+	bool valid_handle;
+
+	WARN_ON(client != handle->client);
+
+	valid_handle = ion_handle_validate(client, handle);
+	if (!valid_handle) {
+		WARN(1, "%s: invalid handle passed to free.\n", __func__);
+		return;
+	}
+	if (handle->user_ref_count == 0) {
+		WARN(1, "%s: User does not have access!\n", __func__);
+		return;
+	}
+	user_ion_handle_put_nolock(handle);
+}
+
 static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
 {
 	int ret = 0;
@@ -102,7 +165,7 @@ long ion_ioctl(struct file *filp, unsign
 				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-
+		pass_to_user(handle);
 		data.allocation.handle = handle->id;
 
 		cleanup_handle = handle;
@@ -118,7 +181,7 @@ long ion_ioctl(struct file *filp, unsign
 			mutex_unlock(&client->lock);
 			return PTR_ERR(handle);
 		}
-		ion_free_nolock(client, handle);
+		user_ion_free_nolock(client, handle);
 		ion_handle_put_nolock(handle);
 		mutex_unlock(&client->lock);
 		break;
@@ -146,10 +209,15 @@ long ion_ioctl(struct file *filp, unsign
 		struct ion_handle *handle;
 
 		handle = ion_import_dma_buf_fd(client, data.fd.fd);
-		if (IS_ERR(handle))
+		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-		else
-			data.handle.handle = handle->id;
+		} else {
+			handle = pass_to_user(handle);
+			if (IS_ERR(handle))
+				ret = PTR_ERR(handle);
+			else
+				data.handle.handle = handle->id;
+		}
 		break;
 	}
 	case ION_IOC_SYNC:
@@ -175,8 +243,10 @@ long ion_ioctl(struct file *filp, unsign
 	if (dir & _IOC_READ) {
 		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
 			if (cleanup_handle) {
-				ion_free(client, cleanup_handle);
-				ion_handle_put(cleanup_handle);
+				mutex_lock(&client->lock);
+				user_ion_free_nolock(client, cleanup_handle);
+				ion_handle_put_nolock(cleanup_handle);
+				mutex_unlock(&client->lock);
 			}
 			return -EFAULT;
 		}
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -363,8 +363,8 @@ struct ion_handle *ion_handle_get_by_id_
 	return ERR_PTR(-EINVAL);
 }
 
-static bool ion_handle_validate(struct ion_client *client,
-				struct ion_handle *handle)
+bool ion_handle_validate(struct ion_client *client,
+			 struct ion_handle *handle)
 {
 	WARN_ON(!mutex_is_locked(&client->lock));
 	return idr_find(&client->idr, handle->id) == handle;
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -149,6 +149,7 @@ struct ion_client {
  */
 struct ion_handle {
 	struct kref ref;
+	unsigned int user_ref_count;
 	struct ion_client *client;
 	struct ion_buffer *buffer;
 	struct rb_node node;
@@ -459,6 +460,9 @@ int ion_sync_for_device(struct ion_clien
 struct ion_handle *ion_handle_get_by_id_nolock(struct ion_client *client,
 						int id);
 
+bool ion_handle_validate(struct ion_client *client,
+			 struct ion_handle *handle);
+
 void ion_free_nolock(struct ion_client *client, struct ion_handle *handle);
 
 int ion_handle_put_nolock(struct ion_handle *handle);



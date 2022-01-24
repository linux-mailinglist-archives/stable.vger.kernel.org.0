Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1563649846F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243623AbiAXQMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243608AbiAXQMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:12:49 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3E7C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:48 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w11so2372189wra.4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hDJ24WekibmtPtU5K8WcaBpvEcctJ1LGjOJIq+tvKpo=;
        b=O8vSU8Y3TGnZdAzugkRkaQlfbrOflLa6IUZwJig8hTemKjcZuxlO+frzuRKgWh/Zc5
         CwjOa/Z2tpat7ml8rmS2Gh7GRIOoiyKCXMCjdFW+0tNK0hRqNswP0G92Y0ZVDZ5f19x0
         O7gdCtxHqH8SizHrlK+jHUVH2nPNs5kwMGNgFDXQy34ZkS21fJqLBCY+wuqVY9nzEmPz
         wi2gySHsl6GXhemgMi2WAZq5xOloy7sAmqqMmbYB1Ykki/ymXkNRAtXjlHVRl0izYlkZ
         kQCeRIyqFXMPBYI5S6ovNyfP7CSpn5bHkfH2WOxkMiw4IDZbA5mymRSkqKB83iNQZry3
         G5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDJ24WekibmtPtU5K8WcaBpvEcctJ1LGjOJIq+tvKpo=;
        b=jBhVMXrnPziXy8ivQVBMPvnRz4pKQ+0FhYdQ1etVyWzW14UlwWPar1hO5P0XNbBS79
         z3b6ckpDdHBur4l3kTUQFfJBHGYC28D7nXGr6GLC+MNVowbFMfbD529nfAo4Q7gYwj3l
         rHgHr4Gd3MqM1lKZ2H3g1ONLC90eKF/ed2d4DJJ8n1UJ8O5xXaWJZAQ9A83qYxPoy2/P
         BHCFvmxj2VJnNy5XdgWP/exSyfEdAyh33bPrZQX1vQWKcCVXKY7GlzDTMWve0TbTpFGR
         gvGsNNKE2Y3Ucxx252c51VJ2Y4JEz7VQLfq3uFcow3etcwzyS7NvT4clOkACuIxbzSUo
         WtZQ==
X-Gm-Message-State: AOAM533AzK12Qkqx7B/inYbI6yN2XQOLMmR1yMzJUygZvtdKZJFs4Yxy
        U32Eu8dvWfhZET3WCAfdZ38J3g==
X-Google-Smtp-Source: ABdhPJxCBWmyBLH9Yeuq2Jk+N48m/QxxIrXB5psmrL4vp+X/PLtdoq6Dk7dAXU6bSl+V2NMtLfjHTQ==
X-Received: by 2002:adf:ea41:: with SMTP id j1mr14754782wrn.649.1643040767494;
        Mon, 24 Jan 2022 08:12:47 -0800 (PST)
Received: from joneslee-l.roam.corp.google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id u15sm2245583wrs.17.2022.01.24.08.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:12:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>
Subject: [PATCH 4.9 2/3] ion: Protect kref from userspace manipulation
Date:   Mon, 24 Jan 2022 16:12:42 +0000
Message-Id: <20220124161243.1029417-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124161243.1029417-1-lee.jones@linaro.org>
References: <20220124161243.1029417-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
---
 drivers/staging/android/ion/ion-ioctl.c | 84 ++++++++++++++++++++++---
 drivers/staging/android/ion/ion.c       |  4 +-
 drivers/staging/android/ion/ion_priv.h  |  4 ++
 3 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index f260e0e70488f..d47e9b4171e28 100644
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
@@ -102,7 +165,7 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-
+		pass_to_user(handle);
 		data.allocation.handle = handle->id;
 
 		cleanup_handle = handle;
@@ -118,7 +181,7 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			mutex_unlock(&client->lock);
 			return PTR_ERR(handle);
 		}
-		ion_free_nolock(client, handle);
+		user_ion_free_nolock(client, handle);
 		ion_handle_put_nolock(handle);
 		mutex_unlock(&client->lock);
 		break;
@@ -146,10 +209,15 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
@@ -175,8 +243,10 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 4f769213be1b7..b272f2ab87e8f 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -363,8 +363,8 @@ struct ion_handle *ion_handle_get_by_id_nolock(struct ion_client *client,
 	return ERR_PTR(-EINVAL);
 }
 
-static bool ion_handle_validate(struct ion_client *client,
-				struct ion_handle *handle)
+bool ion_handle_validate(struct ion_client *client,
+			 struct ion_handle *handle)
 {
 	WARN_ON(!mutex_is_locked(&client->lock));
 	return idr_find(&client->idr, handle->id) == handle;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 760e41885448a..e1dd25eab1dbd 100644
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
@@ -459,6 +460,9 @@ int ion_sync_for_device(struct ion_client *client, int fd);
 struct ion_handle *ion_handle_get_by_id_nolock(struct ion_client *client,
 						int id);
 
+bool ion_handle_validate(struct ion_client *client,
+			 struct ion_handle *handle);
+
 void ion_free_nolock(struct ion_client *client, struct ion_handle *handle);
 
 int ion_handle_put_nolock(struct ion_handle *handle);
-- 
2.35.0.rc0.227.g00780c9af4-goog


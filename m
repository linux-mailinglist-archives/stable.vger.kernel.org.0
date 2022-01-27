Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A435F49E9BA
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbiA0SJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244846AbiA0SJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62358B820C9;
        Thu, 27 Jan 2022 18:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED7DC340E4;
        Thu, 27 Jan 2022 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306943;
        bh=htoVF5ZfJWB3/zajqc1n5Q/86/CYvLYPQlBYmei5xYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFZC/E/9KH19f7BXOam+EM9AJMEaN4y0QIJeLe2N0ZLJ7ka/+SznZQSuV6jgYelYt
         UGkOpUEiNCvV+2Rt4ufTU4Wp1DtrNtL4Wh81NVlgbtJKn+vH9zB+g3yxnGNE1I5YZB
         I4weZ5VMsb7NU2e6lgW6v8RtQiGoZfx1jsyXH0e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: [PATCH 4.9 7/9] ion: Fix use after free during ION_IOC_ALLOC
Date:   Thu, 27 Jan 2022 19:08:25 +0100
Message-Id: <20220127180257.454803332@linuxfoundation.org>
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

If a user happens to call ION_IOC_FREE during an ION_IOC_ALLOC
on the just allocated id, and the copy_to_user fails, the cleanup
code will attempt to free an already freed handle.

This adds a wrapper for ion_alloc that adds an ion_handle_get to
avoid this.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Dennis Cagle <d-cagle@codeaurora.org>
Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/android/ion/ion-ioctl.c |   14 +++++++++-----
 drivers/staging/android/ion/ion.c       |   15 ++++++++++++---
 drivers/staging/android/ion/ion.h       |    4 ++++
 3 files changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -96,10 +96,10 @@ long ion_ioctl(struct file *filp, unsign
 	{
 		struct ion_handle *handle;
 
-		handle = ion_alloc(client, data.allocation.len,
-						data.allocation.align,
-						data.allocation.heap_id_mask,
-						data.allocation.flags);
+		handle = __ion_alloc(client, data.allocation.len,
+				     data.allocation.align,
+				     data.allocation.heap_id_mask,
+				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 
@@ -174,10 +174,14 @@ long ion_ioctl(struct file *filp, unsign
 
 	if (dir & _IOC_READ) {
 		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
-			if (cleanup_handle)
+			if (cleanup_handle) {
 				ion_free(client, cleanup_handle);
+				ion_handle_put(cleanup_handle);
+			}
 			return -EFAULT;
 		}
 	}
+	if (cleanup_handle)
+		ion_handle_put(cleanup_handle);
 	return ret;
 }
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -401,9 +401,9 @@ static int ion_handle_add(struct ion_cli
 	return 0;
 }
 
-struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
-			     size_t align, unsigned int heap_id_mask,
-			     unsigned int flags)
+struct ion_handle *__ion_alloc(struct ion_client *client, size_t len,
+			       size_t align, unsigned int heap_id_mask,
+			       unsigned int flags, bool grab_handle)
 {
 	struct ion_handle *handle;
 	struct ion_device *dev = client->dev;
@@ -453,6 +453,8 @@ struct ion_handle *ion_alloc(struct ion_
 		return handle;
 
 	mutex_lock(&client->lock);
+	if (grab_handle)
+		ion_handle_get(handle);
 	ret = ion_handle_add(client, handle);
 	mutex_unlock(&client->lock);
 	if (ret) {
@@ -462,6 +464,13 @@ struct ion_handle *ion_alloc(struct ion_
 
 	return handle;
 }
+
+struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
+			     size_t align, unsigned int heap_id_mask,
+			     unsigned int flags)
+{
+	return __ion_alloc(client, len, align, heap_id_mask, flags, false);
+}
 EXPORT_SYMBOL(ion_alloc);
 
 void ion_free_nolock(struct ion_client *client,
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -109,6 +109,10 @@ struct ion_handle *ion_alloc(struct ion_
 			     size_t align, unsigned int heap_id_mask,
 			     unsigned int flags);
 
+struct ion_handle *__ion_alloc(struct ion_client *client, size_t len,
+			       size_t align, unsigned int heap_id_mask,
+			       unsigned int flags, bool grab_handle);
+
 /**
  * ion_free - free a handle
  * @client:	the client



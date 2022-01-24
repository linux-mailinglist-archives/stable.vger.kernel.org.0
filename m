Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C992F49846E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243614AbiAXQMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243609AbiAXQMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:12:48 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11791C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l25so14508701wrb.13
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3qM4YgysVmXuR9T7fw30GzZ17gmbX+VaA/wkp7fa1U=;
        b=s0eDtmxl4Wn+8Kvoh+6fVtKn0fFLct8O5yklXEA0Q0GdYvEkVQPYOlAFUisN4tc9mN
         mNWIXN9z+FzCIupQcuHIurRneBvUCVtPizsisSXyNv6hAvBGeEtTspfuqd+0wgyQBxPi
         44KB+e4XLgr18I/GzLnz2gVqKZoeESpH1QkaPdSGkzsF98ah+oBaEjEtTktPIuvKnUBf
         jeSa56RxVQwn40tkI+dsg7NztvitrBmxeyhFzAwiYIARPj5TUjJo/vNNGdLkMw4TW6WZ
         zGdcggCcaK1OoHoPAqe7gx7pysjPns9F9RU8sEsbBCWXOPqtAzVyqJI5SnE2GUdi4Xww
         SEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3qM4YgysVmXuR9T7fw30GzZ17gmbX+VaA/wkp7fa1U=;
        b=uajC27jTaBktLhDzf/KGRpLVmTe2yUvSE655j94/K/7AOGRz/KTjOGusPradH9gTWB
         4sI2ZhbGVg/T2kyg5X8SZOcWeKRAWX/qwMTo5vNGLIt4xVxirRz4NHnzYuKDBykihxo1
         /clBB3kTYbrJDPMqpzkGyDoSzFypPc/cpxBEsqGOP5XPR8tzv7YVoIMNXKmQVfBI2mgV
         InD24QiinInl92R6r8CcsB+Rwf4oZKG7NLAwCjo/Yl3N1U4h7QAiGB8NPBCfBBl6rdz6
         3jpxlC767Rv2LPFAlOnA1omLhn004ZeT4HW/GCPO9T9HsFUnNqhPnNe5D7EyGAX95W5e
         5LCQ==
X-Gm-Message-State: AOAM5321W+DCYE2dmU+F+BTz4sukOlWIzLXh4fO8B4tHHzo4uyTTz0ZS
        PaOov3Y0ZyrwcAjyOlAtDOuntQ==
X-Google-Smtp-Source: ABdhPJwwskhyXYayPI9i4WQvhgow2/z4EBX1tCETtZFQgNuAIbhYmFtHEku9r9dY1zZX9/+px8mE5A==
X-Received: by 2002:adf:eccb:: with SMTP id s11mr15045860wro.422.1643040766624;
        Mon, 24 Jan 2022 08:12:46 -0800 (PST)
Received: from joneslee-l.roam.corp.google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id u15sm2245583wrs.17.2022.01.24.08.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:12:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: [PATCH 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Date:   Mon, 24 Jan 2022 16:12:41 +0000
Message-Id: <20220124161243.1029417-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
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
---
 drivers/staging/android/ion/ion-ioctl.c | 14 +++++++++-----
 drivers/staging/android/ion/ion.c       | 15 ++++++++++++---
 drivers/staging/android/ion/ion.h       |  4 ++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index e3596855a7031..f260e0e70488f 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -96,10 +96,10 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
 
@@ -174,10 +174,14 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
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
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index aac9b38b8c25c..4f769213be1b7 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -401,9 +401,9 @@ static int ion_handle_add(struct ion_client *client, struct ion_handle *handle)
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
@@ -453,6 +453,8 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 		return handle;
 
 	mutex_lock(&client->lock);
+	if (grab_handle)
+		ion_handle_get(handle);
 	ret = ion_handle_add(client, handle);
 	mutex_unlock(&client->lock);
 	if (ret) {
@@ -462,6 +464,13 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 
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
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 93dafb4586e43..cfa50dfb46edc 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -109,6 +109,10 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 			     size_t align, unsigned int heap_id_mask,
 			     unsigned int flags);
 
+struct ion_handle *__ion_alloc(struct ion_client *client, size_t len,
+			       size_t align, unsigned int heap_id_mask,
+			       unsigned int flags, bool grab_handle);
+
 /**
  * ion_free - free a handle
  * @client:	the client
-- 
2.35.0.rc0.227.g00780c9af4-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1E49B629
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384822AbiAYOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1578320AbiAYOSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:18:17 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A8AC061755
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:18:12 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u15so20194485wrt.3
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6+Y0ehoRlYeXcfvU+4+73BNj7+BllTLh4l/lh7e6zc=;
        b=WkfmB3nKIBcfXDx8mcztS6k/T8dlLkWuG3BnWk/PY6YSe/kBEKpVUor59JsJLpB6Mv
         A2OuzXjXm0CqOCmzilaeb6WG/AP0Y0kkWM8MXh7caWY2rWo+aPbeSjopx+fsFut6kERl
         B+QLWcz09ZaI5hnL6S5NOSIsoiC0TdbUH/1RaHAya67rzcOfbxUfKgt1UUqHr72vk7AE
         Rf1C/EfLZfyBZbGDWjEPf2qTfZEZpVT+F5mKtDjB2psYS017Sa+TgvAmy2f75XVeq25v
         7OOsAjtROfslNqABgMxq9LaHP6xtRKkcA6PgLzke/VD2GtLf0mOpGoBEPyXolIUDpBG+
         Hpqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y6+Y0ehoRlYeXcfvU+4+73BNj7+BllTLh4l/lh7e6zc=;
        b=EoJlMdnJptxhAbsmJ9D/amPc9N0yHhedFS158n2gowLlVpFfFTlgaFpnulBv8RUcjc
         2fqN3mIdbLRXAgtaKqfEd3MJmSW791dONXvZvnbwZln+pdLp6iUzy76UmkiqiFWMaZep
         Fxlqoj4dIb6FRuRXE4xzGvM3KXIyXe1JeXU9LOaF+YEA+fVT9mnt83BkxYPcxsNdE/Lb
         fc6q+gQYHE/oV71yLo9FNcKP/NQiOJJOyTSACuZlHwL/SwacqjmtoHdddZDA1bG3bota
         L+Li+JYV5S+3l3rqrbYRLohe3WhpCK0wk/8JdT14cOg7m13BMUwx5UPQnQrGpgDDo+Hg
         0qiQ==
X-Gm-Message-State: AOAM533MHWivj7EMw1Jj04yCz9Xu0R4zj8jI52BdulBQXdL53B8YFaOX
        mwA+nauiz7EMLUwf6R+huekV4Q==
X-Google-Smtp-Source: ABdhPJykrS956me24RymfDmb5IeN2+lfGMqaQgdUOblOMZLqz3DwttxaC81171n+CNbVsRGu8c1jxQ==
X-Received: by 2002:a05:6000:2c6:: with SMTP id o6mr7900892wry.601.1643120291059;
        Tue, 25 Jan 2022 06:18:11 -0800 (PST)
Received: from joneslee-l.roam.corp.google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id bg23sm699740wmb.5.2022.01.25.06.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:18:10 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Dennis Cagle <d-cagle@codeaurora.org>,
        Patrick Daly <pdaly@codeaurora.org>
Subject: [PATCH v2 4.9 1/3] ion: Fix use after free during ION_IOC_ALLOC
Date:   Tue, 25 Jan 2022 14:18:06 +0000
Message-Id: <20220125141808.1172511-1-lee.jones@linaro.org>
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

NB: These are Android patches that were not sent to Mainline.

Only v4.9 is affected by these issues due to refactoring.

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


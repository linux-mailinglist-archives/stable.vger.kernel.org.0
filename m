Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0C769A7A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 20:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfGOSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 14:06:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39581 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfGOSG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 14:06:29 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so35583492ioh.6
        for <stable@vger.kernel.org>; Mon, 15 Jul 2019 11:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kSl/+ShDI5KAfLeYGkxFbXM6CRqA8nt+tBShhfR/JaU=;
        b=Zwp/9F/ais1tgKVSS9S5+OplDTmjWODzJmiVkKhS7ksI2qzFzUQ4AQT/5RsnDFpupK
         W+uA4AtDDn7gmzpg9act1XZGDy57lPmbjXZIWmIvae2k2hsTVnyoI4iiy/Y4/gYRyeiZ
         dGwyETjdQqGLapir9pI6oNtMWH/43k2+kBV9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSl/+ShDI5KAfLeYGkxFbXM6CRqA8nt+tBShhfR/JaU=;
        b=VIpeQ/f8fF1+KWTuwnOvMOT24lrL+oFfDGt9QeAtQ5AidSObbGEfN2pS25lX8V+sC0
         n+s4aCokJfxGdky8K3q+gtOzdVRsxEM266v7XLDMuhB125nr3sqmRPl/iu3N6Y5Il2vH
         yqtoM6dAZaLA1TjoYFywy/j//HTI/fmTrjAHgLTV3dBXPOodMttKwCHy0wjw03BljHEc
         NGFP0zar1K59ocxINBWlp3g9hDEo8Rz5+VJK3tWhD5e9UjOlLHspi554ShWNbvMDPeIs
         KmgEnlmyn/43u35ZanHzHjdgdS3ijE7QkAxU0TPChDJSIMgKHdME7aT133OYuRzzXl/0
         peJw==
X-Gm-Message-State: APjAAAUffc+80ywQhvH7fkXzpScWk8FclvQ/NIpLKI5O3bCWzXrITFb0
        VG1gWdchRbCKf5TWfZCbpWaaYXRXiNE=
X-Google-Smtp-Source: APXvYqzS1eT3JvdZueCvhw+Rv8D6W3gHXQIoXzpCjELi53ZiCcfh4EuOCaZHTQmJUijVUwy2vh2PLw==
X-Received: by 2002:a5e:8f42:: with SMTP id x2mr25420957iop.35.1563213988159;
        Mon, 15 Jul 2019 11:06:28 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id p63sm18937060iof.45.2019.07.15.11.06.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 11:06:27 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     stable@vger.kernel.org
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Airlie <airlied@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Sean Paul <seanpaul@chromium.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [v4.19.y PATCH 2/3] drm/udl: Replace drm_dev_unref with drm_dev_put
Date:   Mon, 15 Jul 2019 12:05:57 -0600
Message-Id: <20190715180558.221737-3-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715180558.221737-1-zwisler@google.com>
References: <20190715180558.221737-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ac3b35f11a06964f5fe7f6ea9a190a28a7994704 upstream.

This patch unifies the naming of DRM functions for reference counting
of struct drm_device. The resulting code is more aligned with the rest
of the Linux kernel interfaces.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20180926120212.25359-1-tzimmermann@suse.de
Signed-off-by: Ross Zwisler <zwisler@google.com>
---
 drivers/gpu/drm/udl/udl_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_drv.c b/drivers/gpu/drm/udl/udl_drv.c
index 54e767bd5ddb..bd4f0b88bbd7 100644
--- a/drivers/gpu/drm/udl/udl_drv.c
+++ b/drivers/gpu/drm/udl/udl_drv.c
@@ -95,7 +95,7 @@ static int udl_usb_probe(struct usb_interface *interface,
 	return 0;
 
 err_free:
-	drm_dev_unref(dev);
+	drm_dev_put(dev);
 	return r;
 }
 
-- 
2.22.0.510.g264f2c817a-goog


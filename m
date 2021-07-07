Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC33BED86
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 19:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhGGR5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 13:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhGGR5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 13:57:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0815BC061574;
        Wed,  7 Jul 2021 10:54:35 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id v14so6118049lfb.4;
        Wed, 07 Jul 2021 10:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZpmDCIz0rIGK47pS6w8JzmqA/aA+YixYTwCoaSlrnc=;
        b=E0/p0hqryKCZWz6zf9caFhG/blb0UAzoveQkdWBy7FIUcKFy3D5ouO0goA1YwclnLT
         c9QI56auMm2qY1kpTMWZkAJCmbyIJCrNWrMWe6R+LxNJkLoYPcp2e/J5oMUiytDg2N0e
         i8eHoecUlFMpUToxFScDHPG79t78rEIozbDtRthX3fXJD78UwDZQKUvMA5ZjiC3mHl8J
         cyDQjtletcnCmz/b6T0dPyGgvkOEiAHY5IyZaIHsmGKAboDbLXdriPz/7YNNvWjhm7Nb
         xGz34JHZem3RskTxCB18SRMNXll+sSnWBapsazWqhv3UqFIVejXWhphQo/yTY7JCdTMD
         sMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HZpmDCIz0rIGK47pS6w8JzmqA/aA+YixYTwCoaSlrnc=;
        b=iMaN2ala6H25XI9+lWbAjy5A4ZoEEJ2Tg3h3IkK57GRUSzqlf0dWqUrtPxjliYIORz
         gn3ddnY40ibVTIj/yNvQUgGGBzDta+XniJskcfZ2C4tc3vUJG4x1ShX8flAfc8YhXtms
         RHhXAGkhoS55qDsqygpZFnzSxbbUwES4PauDF5nTUw6olpUw0RTzdp+LnU/K5TdqJtsT
         snrse8Dig1l7YXDG6UqbckNQKn1MN9E527zj9viMbKmgybcvIavD9qbNsCEUgtikf9B/
         YGy6oZQvMmlqEs8PELCm5mR8ooxtZ6RrLAsRGUWQCU0wSGantlzChW61XE1pd7zdwtBg
         8mUw==
X-Gm-Message-State: AOAM530SPfYzcgshCKka0MIlUMKiesJoLmQodduEHFuFm282LwRwifC3
        7cuWlLIdthNvdVVvzhDd3N4Ur/4a+J9RPA==
X-Google-Smtp-Source: ABdhPJz5CVwGGqWzlzZS4on1/Hstress7Qt0eaxM5wrDBX+jviNc+ukzcaFHNystsXA4dTL1Dc9TeA==
X-Received: by 2002:ac2:4345:: with SMTP id o5mr19628396lfl.599.1625680473222;
        Wed, 07 Jul 2021 10:54:33 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id f19sm1252303lfs.133.2021.07.07.10.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 10:54:32 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mchehab@kernel.org, jsagarribay@gmail.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] media: stkwebcam: fix memory leak in stk_camera_probe
Date:   Wed,  7 Jul 2021 20:54:30 +0300
Message-Id: <20210707175430.23204-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My local syzbot instance hit memory leak in usb_set_configuration().
The problem was in unputted usb interface. In case of errors after
usb_get_intf() the reference should be putted to correclty free memory
allocated for this interface.

Fixes: ec16dae5453e ("V4L/DVB (7019): V4L: add support for Syntek DC1125 webcams")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index a45d464427c4..0e231e576dc3 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1346,7 +1346,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	if (!dev->isoc_ep) {
 		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1359,10 +1359,12 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	err = stk_register_video_device(dev);
 	if (err)
-		goto error;
+		goto error_put;
 
 	return 0;
 
+error_put:
+	usb_put_intf(interface);
 error:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
-- 
2.32.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01810E826
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfLBKEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51223 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfLBKEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id g206so21091919wme.1
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wtROsbUjoLDB5bCQoEYMpQvwKrmALV6Kqcb0leG5CiM=;
        b=DSAhHkT4ABXACx+/YINknwIGxRO/Z6C9ZGgTY1Jp+bzKmgIig9ZZb45L9xTp7ea1hp
         /raeG28Q2hN3Y68iop02u6b74gAwagvMUui0AybmFKrTZn1Wf3rqR04iMID5622xeQuo
         /zpAQ0oqiEh/h6oulX4arXz1j+voAm8tLY/rsMe7ZoBWG6uhPwUUMmE/c28HULOecdvc
         XxJpCr8A83P3d5tFtU0rHa1B6r+Cmqffjde9qm3nGQZbWtqRv8Vh5Ey+6FWdiNFe6Ax9
         qRpc07w/NFzrfpCESNCqb8TmkZZ69UAdgfUD3LbWORV3ZYS9Ib3yz5ciHhLyLGmTal0L
         YoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtROsbUjoLDB5bCQoEYMpQvwKrmALV6Kqcb0leG5CiM=;
        b=nz8u57C1uylbs9IxGq4F767qGm4pZF+ybCUGySXCHs60qQvPIacudFT7aDAcDitIWb
         jyX5Sa/a22YZngz5Zsfp+D7Il8zTapE83qxoxumYsYym5Ehcw8w5dme6Ehl0k4ihqMj4
         qFoFRusw2us9mLP9p08jvEr8d6zhvEzXCw/c0ggiVTHmX1yCbSBmjRTO38mFyj2q8llR
         GtmEia+DJTG9VkAEdxMTtSif6EtNaCfKZ6MgU7Nmr3pqULEWAwjUN8TTn6fTFwwAxOd6
         6jJL8vSdMaLSp3Jc8qE9E/V1pax0bmf/SEIyk8+yCQ6Pud9IA5hri3OXDLrepKdzw7ae
         EImg==
X-Gm-Message-State: APjAAAVzj0Ki4+mQq2IKXMDRqQeeIjXZanO77AaAbqYyZAmtP92JEW8S
        TrIf2veC1cmQ5REJsIAtx5Q/I+GXY7s=
X-Google-Smtp-Source: APXvYqxGXJDxchH5iBqxH1kXbk/TnpI/H32nITxdamRSfzK9TKYJvpmG02SF2+OFNN+3Wcsuaq8ugQ==
X-Received: by 2002:a1c:7306:: with SMTP id d6mr6903830wmb.164.1575281037159;
        Mon, 02 Dec 2019 02:03:57 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:56 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 08/14] media: atmel: atmel-isc: fix INIT_WORK misplacement
Date:   Mon,  2 Dec 2019 10:03:06 +0000
Message-Id: <20191202100312.1397-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 79199002db5c571e335131856b3ff057ffd9f3c0 ]

In case the completion function failes, unbind will be called
which will call cancel_work for awb_work.
This will trigger a WARN message from the workqueue.
To avoid this, move the INIT_WORK call at the start of the completion
function. This way the work is always initialized, which corresponds
to the 'always canceled' unbind code.

Fixes: 93d4a26c3d ("[media] atmel-isc: add the isc pipeline function")

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/platform/atmel/atmel-isc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 504d1ca0330e..0dea3cf2cb52 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1555,6 +1555,8 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	struct vb2_queue *q = &isc->vb2_vidq;
 	int ret;
 
+	INIT_WORK(&isc->awb_work, isc_awb_work);
+
 	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev, "Failed to register subdev nodes\n");
@@ -1614,8 +1616,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	INIT_WORK(&isc->awb_work, isc_awb_work);
-
 	/* Register video device */
 	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
 	vdev->release		= video_device_release_empty;
-- 
2.24.0


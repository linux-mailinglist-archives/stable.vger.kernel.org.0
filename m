Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8166910E8E8
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfLBKbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39499 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLBKbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id s14so15818655wmh.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=R8AAvwaj+CXQP64zDDHz2NkHRoMaj2Fuj9qQc9YxRqk=;
        b=ogc8ONl5ioZV7aVelcXGrPpSCvjgc3g2Ooy9Pt4SC4ciKp43/jpvMIW4q8HsK5HF9z
         5iFF6eN+6mjxPWOwlS5sH2FeQZLrcUPdvABC5u9fvqe6uQRct89CNjck4NVIX40UPkQU
         adeTW4UrBoV9Ci5v5AG8Ztat70aly8cuuOyjv55BJK66qjmpQzucTrCzB+wA48WxfkG2
         roCZ/HwVA6l5Av4rHcI50FuqQchC8vNlEuo0T5Ujfq/L8O3VbdgDO1MCMqqTxsp0LAT6
         yXs+d0U90uffrweyt6VdJvVy7pL5fsT3XIffkMNbD2f8RHw87zj6L0rEXt2+sn7DHp1i
         Rxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8AAvwaj+CXQP64zDDHz2NkHRoMaj2Fuj9qQc9YxRqk=;
        b=iapdwLuT1yyDyNAdxA6XOoO4EMAc0X3ts7JyBtVJQqinimHEcwJorVedA2ov1nNqj6
         DXddjHZW7ZN5Y/6KhdT05jj92b07+NxOiFyhsY8ATrKzrJnn2c+NStgiJhkwiqYbdLdf
         PMIqpe5l0xNZkjur6CkVFD5yWMEOhgGe5uhfdVq7EmQgJm8mhmGQJ/e5F8uutQ+Wabtt
         fmU4eK3Uk5OUayum4oHav3nSP3CJgZ5pyJ+xFwPao7h+KIvD+nByzjuz36yXpyygI9g6
         fzHB9Ggtl5d10Ul8FT8/9m8iITOTYVdXgZ/NggvfjdVrUIRHhtE8rvRCkUugozFxUHw7
         jkEA==
X-Gm-Message-State: APjAAAV/SpjeR+LtJC+FHPNdXC+/TAmfC2PtkR9v8W+oXdM6lyX1Vetf
        4hcwj8Xzmuk0YISptbijYjrV3sH3sM8=
X-Google-Smtp-Source: APXvYqwMLZ7dNYUhsHdCVz12CVvcRdfZtvBvIuhuk/pnSbkvgmQxWk515+mU6qwfKJayY7yBgAL3MQ==
X-Received: by 2002:a05:600c:290e:: with SMTP id i14mr27115656wmd.126.1575282674377;
        Mon, 02 Dec 2019 02:31:14 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:13 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 09/15] media: atmel: atmel-isc: fix INIT_WORK misplacement
Date:   Mon,  2 Dec 2019 10:30:44 +0000
Message-Id: <20191202103050.2668-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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
index f2b09ea107b1..1fd078257670 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1895,6 +1895,8 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	struct vb2_queue *q = &isc->vb2_vidq;
 	int ret;
 
+	INIT_WORK(&isc->awb_work, isc_awb_work);
+
 	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev, "Failed to register subdev nodes\n");
@@ -1948,8 +1950,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	INIT_WORK(&isc->awb_work, isc_awb_work);
-
 	/* Register video device */
 	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
 	vdev->release		= video_device_release_empty;
-- 
2.24.0


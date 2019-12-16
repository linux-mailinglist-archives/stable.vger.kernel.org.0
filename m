Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAE412123F
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfLPRvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfLPRvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A92720717;
        Mon, 16 Dec 2019 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518663;
        bh=FF58ieEJNxPNo1PmXySZJPrOm/irqBsD3ezl4GwH7Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5ZqaclcRTSFDHhQWY8jmA+Xq42QW1pd7jaKiA+s1LkQLDTPMo24WeFljPNQkaVEi
         DYwDVbWreavrai/GK5SaeaVYXA/BrD5KTWAqT9rW/bFPH6DCKhej+alfiD2ezw+BLK
         I6i1+qnCdh8wv3/bWOGrfAprNsG/OZO55brpW5LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 016/267] Input: cyttsp4_core - fix use after free bug
Date:   Mon, 16 Dec 2019 18:45:42 +0100
Message-Id: <20191216174850.846222029@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 79aae6acbef16f720a7949f8fc6ac69816c79d62 ]

The device md->input is used after it is released. Setting the device
data to NULL is unnecessary as the device is never used again. Instead,
md->input should be assigned NULL to avoid accessing the freed memory
accidently. Besides, checking md->si against NULL is superfluous as it
points to a variable address, which cannot be NULL.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/1572936379-6423-1-git-send-email-bianpan2016@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/cyttsp4_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index beaf61ce775b7..a9af83de88bb2 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -1972,11 +1972,6 @@ static int cyttsp4_mt_probe(struct cyttsp4 *cd)
 
 	/* get sysinfo */
 	md->si = &cd->sysinfo;
-	if (!md->si) {
-		dev_err(dev, "%s: Fail get sysinfo pointer from core p=%p\n",
-			__func__, md->si);
-		goto error_get_sysinfo;
-	}
 
 	rc = cyttsp4_setup_input_device(cd);
 	if (rc)
@@ -1986,8 +1981,6 @@ static int cyttsp4_mt_probe(struct cyttsp4 *cd)
 
 error_init_input:
 	input_free_device(md->input);
-error_get_sysinfo:
-	input_set_drvdata(md->input, NULL);
 error_alloc_failed:
 	dev_err(dev, "%s failed.\n", __func__);
 	return rc;
-- 
2.20.1




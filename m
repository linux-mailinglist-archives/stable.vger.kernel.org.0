Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61DB14DC2
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfEFOqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfEFOqU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 825D520C01;
        Mon,  6 May 2019 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153980;
        bh=hNMILTvkYrpnJHXR3XQLza2zTz1EDv6P8yTCQHmpAkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Qcn84Zb73cU87jnaZLtax6tm+8AtFVBlMZLBqccRr7+piODyof8ku/CkycuvutBX
         0AiBdr/UasCMMlEgMnjm57fZ+TwvxD+4FF+P2iLkaLW4HlSEXkp/GnMXBmwbqU8Ytd
         cJq/thG7flnwWlHX7gwEX8zFhQgI7uD0X90z2AOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 68/75] Input: snvs_pwrkey - initialize necessary driver data before enabling IRQ
Date:   Mon,  6 May 2019 16:33:16 +0200
Message-Id: <20190506143059.407155755@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <anson.huang@nxp.com>

commit bf2a7ca39fd3ab47ef71c621a7ee69d1813b1f97 upstream.

SNVS IRQ is requested before necessary driver data initialized,
if there is a pending IRQ during driver probe phase, kernel
NULL pointer panic will occur in IRQ handler. To avoid such
scenario, just initialize necessary driver data before enabling
IRQ. This patch is inspired by NXP's internal kernel tree.

Fixes: d3dc6e232215 ("input: keyboard: imx: add snvs power key driver")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/snvs_pwrkey.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/input/keyboard/snvs_pwrkey.c
+++ b/drivers/input/keyboard/snvs_pwrkey.c
@@ -156,6 +156,9 @@ static int imx_snvs_pwrkey_probe(struct
 		return error;
 	}
 
+	pdata->input = input;
+	platform_set_drvdata(pdev, pdata);
+
 	error = devm_request_irq(&pdev->dev, pdata->irq,
 			       imx_snvs_pwrkey_interrupt,
 			       0, pdev->name, pdev);
@@ -171,9 +174,6 @@ static int imx_snvs_pwrkey_probe(struct
 		return error;
 	}
 
-	pdata->input = input;
-	platform_set_drvdata(pdev, pdata);
-
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 
 	return 0;



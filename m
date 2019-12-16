Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D318712162A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbfLPSPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731246AbfLPSPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:15:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120F5206E0;
        Mon, 16 Dec 2019 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520149;
        bh=cMLkqMqK+Gd4sTCmmglswR0S3qcdjkuJPxkvMp7nKAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke3O/pJu31RCt55oNfkcrDhor6nPp7OADwpDQmK6gLfjxzl8tzXS1q4oUA8aJH5wI
         u/10IjgWH1mLlH6UaCRaT5vVuGMWE/L2PatSGBKkP0teRQ3sNwaMPljzAfzSx9gRvE
         rfWmBDgNR6yAgod+KwONj1Eun21RyQixD13Ncp9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Nagarjuna Kristam <nkristam@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-usb@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 5.4 035/177] usb: common: usb-conn-gpio: Dont log an error on probe deferral
Date:   Mon, 16 Dec 2019 18:48:11 +0100
Message-Id: <20191216174828.552457581@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 59120962e4be4f72be537adb17da6881c4b3797c upstream.

This patch makes the printout of the error message for failing to get a
VBUS regulator handle conditional on the error code being something other
than -EPROBE_DEFER.

Deferral is a normal thing, we don't need an error message for this.

Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc: Nagarjuna Kristam <nkristam@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191128134358.3880498-2-bryan.odonoghue@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/common/usb-conn-gpio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -156,7 +156,8 @@ static int usb_conn_probe(struct platfor
 
 	info->vbus = devm_regulator_get(dev, "vbus");
 	if (IS_ERR(info->vbus)) {
-		dev_err(dev, "failed to get vbus\n");
+		if (PTR_ERR(info->vbus) != -EPROBE_DEFER)
+			dev_err(dev, "failed to get vbus\n");
 		return PTR_ERR(info->vbus);
 	}
 



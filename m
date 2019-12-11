Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FED911B581
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbfLKPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbfLKPRW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE09B24654;
        Wed, 11 Dec 2019 15:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077441;
        bh=xlTCbem2gi9LaqW/ch6R47FmwnGQF0tvIApcLDExZyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxPOd25/+ahkUEN58qla2iYxh+xScavTYeIi9KL13+JdyCECvvwGrvL/Z2qrU9UJw
         qYP1wK6W6sekTlgW0XNWI1K/pOHeLHhObCGXj9+mdlPNKJL1MfK9RdGFQl41/3797z
         lt3jBl6Vx0bm0+9/fhcMm++1RL0ZDuLhqeRVW7YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/243] extcon: max8997: Fix lack of path setting in USB device mode
Date:   Wed, 11 Dec 2019 16:03:23 +0100
Message-Id: <20191211150341.930414616@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit a2dc50914744eea9f83a70a5db0486be625e5dc0 ]

MAX8997 driver disables automatic path selection from MicroUSB connector
and manually sets path to either UART or USB lines. However the code for
setting USB path worked only for USB host mode (when ID pin is set
to ground). When standard USB cable (USB device mode) is connected, path
registers are not touched. This means that once the non-USB accessory is
connected to MAX8997-operated micro USB port, the path is no longer set
to USB and USB device mode doesn't work. This patch fixes it by setting
USB path both for USB and USB host modes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon-max8997.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 9f30f4929b729..7a767b66dd865 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -321,12 +321,10 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 {
 	int ret = 0;
 
-	if (usb_type == MAX8997_USB_HOST) {
-		ret = max8997_muic_set_path(info, info->path_usb, attached);
-		if (ret < 0) {
-			dev_err(info->dev, "failed to update muic register\n");
-			return ret;
-		}
+	ret = max8997_muic_set_path(info, info->path_usb, attached);
+	if (ret < 0) {
+		dev_err(info->dev, "failed to update muic register\n");
+		return ret;
 	}
 
 	switch (usb_type) {
-- 
2.20.1




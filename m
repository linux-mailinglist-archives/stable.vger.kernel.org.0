Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EEA121963
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfLPSu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfLPRvi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:51:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C42206EC;
        Mon, 16 Dec 2019 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518697;
        bh=SQ+63E8dRGVFKoxnKVDyx3YwGbAdRpIHTG3O4filuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyjE06+Oszy3e0sG4+hjd03zqxSFaxhN5Z9VC3VTcG0hVLPIaQBRMRpGdrMy1SbPa
         50yEQLpLYSjm4qsMJcYSA4Q8zZQed3UWI3Vk/RDqzwlEL6ZtEQUyJg65Si13jvy7c/
         Bz2CgIhx/2RuLxgxIjlzZH8yZqFMiUBbDRZEv3fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 030/267] extcon: max8997: Fix lack of path setting in USB device mode
Date:   Mon, 16 Dec 2019 18:45:56 +0100
Message-Id: <20191216174852.220072682@linuxfoundation.org>
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
index 4a0612fb9c070..b9b48d45a6dc4 100644
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




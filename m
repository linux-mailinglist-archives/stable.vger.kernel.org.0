Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CF02E38F0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgL1NQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733085AbgL1NQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:16:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66754207CF;
        Mon, 28 Dec 2020 13:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161334;
        bh=Vp37tht4LYIiuS99/4aMDCAyv9doVc/dWN+7hCcm6Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITj8sferiwbitA8BT9SQIpXuANhRE67QoV4ZMi5T+zTBTtQQtruZTF0G1SHtvvct7
         IdUaxEtbsg7CP134LiJdZKwWOkVQ5naF7NyZZZW8eaaS5wlYvNf7DbScuJwGwyZ4u9
         aQ9gIb0aXlDSaMd4qHERnCPQopnxTgLJBRhILZ7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Beginn <linux@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 180/242] Input: goodix - add upside-down quirk for Teclast X98 Pro tablet
Date:   Mon, 28 Dec 2020 13:49:45 +0100
Message-Id: <20201228124913.542046828@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Beginn <linux@simonmicro.de>

[ Upstream commit cffdd6d90482316e18d686060a4397902ea04bd2 ]

The touchscreen on the Teclast x98 Pro is also mounted upside-down in
relation to the display orientation.

Signed-off-by: Simon Beginn <linux@simonmicro.de>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20201117004253.27A5A27EFD@localhost
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 777dd5b159d39..87f5722a67829 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -101,6 +101,18 @@ static const struct dmi_system_id rotated_screen[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "12/19/2014"),
 		},
 	},
+	{
+		.ident = "Teclast X98 Pro",
+		.matches = {
+			/*
+			 * Only match BIOS date, because the manufacturers
+			 * BIOS does not report the board name at all
+			 * (sometimes)...
+			 */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_BIOS_DATE, "10/28/2015"),
+		},
+	},
 	{
 		.ident = "WinBook TW100",
 		.matches = {
-- 
2.27.0




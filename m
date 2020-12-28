Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD542E6530
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388012AbgL1P6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387995AbgL1Nds (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B6D2072C;
        Mon, 28 Dec 2020 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162388;
        bh=iIM2tHMOBC+WoiU3bgfrPJUNfj95wccv3JdIwPv3XOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSSB6xgDl95CEKHbqR0sohqkG4fULuAKovYEyIwsoXqJQy3bNvNmrcKlZ6obYPP4Z
         4YSCpALCCzBJqgZXepFIdJVcbqCtp9LaHSPWDezQgKS0zljsqm1UwD6wHyEJgUyeMY
         ioBLV0kt2h/1KqxRJzToe+woFsFUswW4hKMyQKpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Beginn <linux@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 257/346] Input: goodix - add upside-down quirk for Teclast X98 Pro tablet
Date:   Mon, 28 Dec 2020 13:49:36 +0100
Message-Id: <20201228124932.204723050@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index b20ba65992735..7e480e2364216 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -136,6 +136,18 @@ static const struct dmi_system_id rotated_screen[] = {
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13C12E4330
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407079AbgL1Pd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407177AbgL1Nww (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F3B32064B;
        Mon, 28 Dec 2020 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163532;
        bh=R1QS8i/SeIoKQicGXswRuLWSSq9tOaNM6BlcPED0/UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pbFsRUcW4UQb5z6yBGFOvhsYYj3AR7xm3px984+WV6vtlST3oiy5Qc6wSfyo3Rr09
         yzp3PwPd8nWDNr+YXUfNxVerF3GIx3aB4UDXFMlkOClkf1ze0d2R6psR5Yu5chdQ0R
         Pq/zFeRhhLPAUGabQi0uBCQ9zGANjn5zm0Jz9Fhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Beginn <linux@simonmicro.de>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 319/453] Input: goodix - add upside-down quirk for Teclast X98 Pro tablet
Date:   Mon, 28 Dec 2020 13:49:15 +0100
Message-Id: <20201228124952.561491887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 37b35ab97beb2..bfb945fc33a17 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -137,6 +137,18 @@ static const struct dmi_system_id rotated_screen[] = {
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




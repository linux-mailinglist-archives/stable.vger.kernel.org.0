Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9494512E6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347554AbhKOTkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245179AbhKOTTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB2C6350F;
        Mon, 15 Nov 2021 18:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000991;
        bh=Xl9CXrdLPgcEC7lELflZA9TbHN8aE1cpmesjhxmrT6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPYNKSnUzcA71e3wl92oeecj23ws1SlnX8fAltoPSxMNcKdPgJRFb5zBVApgqd+It
         Ol8M5yCt5qxs8mcgQ47V15dasUQ+oQfLA/LiA+SNmu++T1EfdGu4jE02dZeodOZDPB
         H3SMEBPpble9W/AhHr7YbWi2Ffu2MWLeiBEnh0Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phoenix Huang <phoenix@emc.com.tw>,
        Yufei Du <yufeidu@cs.unc.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 004/917] Input: elantench - fix misreporting trackpoint coordinates
Date:   Mon, 15 Nov 2021 17:51:39 +0100
Message-Id: <20211115165428.878072157@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phoenix Huang <phoenix@emc.com.tw>

commit be896bd3b72b44126c55768f14c22a8729b0992e upstream.

Some firmwares occasionally report bogus data from trackpoint, with X or Y
displacement being too large (outside of [-127, 127] range). Let's drop such
packets so that we do not generate jumps.

Signed-off-by: Phoenix Huang <phoenix@emc.com.tw>
Tested-by: Yufei Du <yufeidu@cs.unc.edu>
Link: https://lore.kernel.org/r/20210729010940.5752-1-phoenix@emc.com.tw
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elantech.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -517,6 +517,19 @@ static void elantech_report_trackpoint(s
 	case 0x16008020U:
 	case 0x26800010U:
 	case 0x36808000U:
+
+		/*
+		 * This firmware misreport coordinates for trackpoint
+		 * occasionally. Discard packets outside of [-127, 127] range
+		 * to prevent cursor jumps.
+		 */
+		if (packet[4] == 0x80 || packet[5] == 0x80 ||
+		    packet[1] >> 7 == packet[4] >> 7 ||
+		    packet[2] >> 7 == packet[5] >> 7) {
+			elantech_debug("discarding packet [%6ph]\n", packet);
+			break;
+
+		}
 		x = packet[4] - (int)((packet[1]^0x80) << 1);
 		y = (int)((packet[2]^0x80) << 1) - packet[5];
 



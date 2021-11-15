Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2C450AA3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhKORM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236498AbhKORL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B95361BFE;
        Mon, 15 Nov 2021 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996143;
        bh=Xl9CXrdLPgcEC7lELflZA9TbHN8aE1cpmesjhxmrT6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsuzY6Dk4SmOBkdrZWQ50iQY4E4FMtTi/aZuHXWo9AJ2Ne94WwtxX7CTMpmBA2gv+
         lSHS5NsrWg1JqK/lBilt342obWKmG8LLkZakMtK72tcEzFrivyhjqyOnQ3yvGrG6hA
         VpvV/Dgh8ls39lbp/AdhIvDQPxcLsZKD1SoTBsCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phoenix Huang <phoenix@emc.com.tw>,
        Yufei Du <yufeidu@cs.unc.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 007/355] Input: elantench - fix misreporting trackpoint coordinates
Date:   Mon, 15 Nov 2021 17:58:51 +0100
Message-Id: <20211115165313.794481727@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
 



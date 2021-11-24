Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE145BC8A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245091AbhKXMbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343788AbhKXMaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59F44610E9;
        Wed, 24 Nov 2021 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756284;
        bh=1JmBukKjrnXRzprbhVQ9UrTE9mZVLG13AXjwuDHE1h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+0iiS6HBu6jFIhQhco0DIfRk7CX5AWrE7hmBwZ3E3/uy7Vol3m00JNK51NTQkHNL
         2Wqkmx0dDgqKuyzv4eBeoZ0nG1ys+MuY7w4L7EutdjxyYrdafHgFECUxkokLzNbrIk
         Ks14vor9//L/JIsxNneHhEdgy0fBZOzyR8Oti27w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phoenix Huang <phoenix@emc.com.tw>,
        Yufei Du <yufeidu@cs.unc.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 004/251] Input: elantench - fix misreporting trackpoint coordinates
Date:   Wed, 24 Nov 2021 12:54:06 +0100
Message-Id: <20211124115710.374484181@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
@@ -431,6 +431,19 @@ static void elantech_report_trackpoint(s
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
 



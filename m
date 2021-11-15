Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4A450EEC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239905AbhKOSV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241346AbhKOSTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65D1D6340A;
        Mon, 15 Nov 2021 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998706;
        bh=Xl9CXrdLPgcEC7lELflZA9TbHN8aE1cpmesjhxmrT6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSrpmcOzFnKl4gUkUJTOn0HrNGKpgyuQ/ARm2MpWccor+h4uH4azry2ybN/8fzYMO
         hfGf9BEYIhx5mt37NDnGjrGttXxYMif3JKHhCJRruvx97rH6dmN7ShHM4LQ5Nq3Nch
         sEyczBQ7U7EDPZXBNZuRrMMWKwlMg8leIfYpmnhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phoenix Huang <phoenix@emc.com.tw>,
        Yufei Du <yufeidu@cs.unc.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.14 004/849] Input: elantench - fix misreporting trackpoint coordinates
Date:   Mon, 15 Nov 2021 17:51:27 +0100
Message-Id: <20211115165420.125416918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
 



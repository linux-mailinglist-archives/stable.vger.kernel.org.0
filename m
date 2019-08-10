Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F92188D7E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfHJUq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55258 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00053h-Uv; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003dw-MZ; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "Vijayakumar Durai" <vijayakumar.durai1@vivint.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.156309352@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 081/157] rt2x00: do not increment sequence number
 while re-transmitting
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vijayakumar Durai <vijayakumar.durai1@vivint.com>

commit 746ba11f170603bf1eaade817553a6c2e9135bbe upstream.

Currently rt2x00 devices retransmit the management frames with
incremented sequence number if hardware is assigning the sequence.

This is HW bug fixed already for non-QOS data frames, but it should
be fixed for management frames except beacon.

Without fix retransmitted frames have wrong SN:

 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1648, FN=0, Flags=........C Frame is not being retransmitted 1648 1
 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1649, FN=0, Flags=....R...C Frame is being retransmitted 1649 1
 AlphaNet_e8:fb:36 Vivotek_52:31:51 Authentication, SN=1650, FN=0, Flags=....R...C Frame is being retransmitted 1650 1

With the fix SN stays correctly the same:

 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=........C
 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C
 88:6a:e3:e8:f9:a2 8c:f5:a3:88:76:87 Authentication, SN=1450, FN=0, Flags=....R...C

Signed-off-by: Vijayakumar Durai <vijayakumar.durai1@vivint.com>
[sgruszka: simplify code, change comments and changelog]
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |  1 -
 drivers/net/wireless/rt2x00/rt2x00mac.c   | 10 ----------
 drivers/net/wireless/rt2x00/rt2x00queue.c | 15 +++++++++------
 3 files changed, 9 insertions(+), 17 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -666,7 +666,6 @@ enum rt2x00_state_flags {
 	CONFIG_CHANNEL_HT40,
 	CONFIG_POWERSAVING,
 	CONFIG_HT_DISABLED,
-	CONFIG_QOS_DISABLED,
 
 	/*
 	 * Mark we currently are sequentially reading TX_STA_FIFO register
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -682,19 +682,9 @@ void rt2x00mac_bss_info_changed(struct i
 			rt2x00dev->intf_associated--;
 
 		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
-
-		clear_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
 	}
 
 	/*
-	 * Check for access point which do not support 802.11e . We have to
-	 * generate data frames sequence number in S/W for such AP, because
-	 * of H/W bug.
-	 */
-	if (changes & BSS_CHANGED_QOS && !bss_conf->qos)
-		set_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags);
-
-	/*
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -201,15 +201,18 @@ static void rt2x00queue_create_tx_descri
 	if (!test_bit(REQUIRE_SW_SEQNO, &rt2x00dev->cap_flags)) {
 		/*
 		 * rt2800 has a H/W (or F/W) bug, device incorrectly increase
-		 * seqno on retransmited data (non-QOS) frames. To workaround
-		 * the problem let's generate seqno in software if QOS is
-		 * disabled.
+		 * seqno on retransmitted data (non-QOS) and management frames.
+		 * To workaround the problem let's generate seqno in software.
+		 * Except for beacons which are transmitted periodically by H/W
+		 * hence hardware has to assign seqno for them.
 		 */
-		if (test_bit(CONFIG_QOS_DISABLED, &rt2x00dev->flags))
-			__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
-		else
+	    	if (ieee80211_is_beacon(hdr->frame_control)) {
+			__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 			/* H/W will generate sequence number */
 			return;
+		}
+
+		__clear_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 	}
 
 	/*


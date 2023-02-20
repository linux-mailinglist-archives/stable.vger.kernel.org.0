Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F55F69CEC3
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjBTOCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjBTOCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:02:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8039B104
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49FA0B80D41
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96595C433EF;
        Mon, 20 Feb 2023 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901714;
        bh=tQkWk6xkAz+VRLI1xUIXWeDsryammfjeZRF5MLhpuwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZLWZS61kFFdnF4sTzJLdxKxLc7A4I73lUxtQ5N3LdDRM4QXVOAi1fnW5qvK8Ia3A
         o5oTUG4hexbo28tvkJVlPAhgsP5UOqqh1aCZNmMM60nsnKUXlCwi9jbCBT2UC57ii4
         8N1aOOR+DEZ3o9PNIMQZxxBrRhyJ3ZrR9qI60FK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Corallo <ntp-lists@mattcorallo.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 101/118] igb: Fix PPS input and output using 3rd and 4th SDP
Date:   Mon, 20 Feb 2023 14:36:57 +0100
Message-Id: <20230220133604.446214632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

commit 207ce626add80ddd941f62fc2fe5d77586e0801b upstream.

Fix handling of the tsync interrupt to compare the pin number with
IGB_N_SDP instead of IGB_N_EXTTS/IGB_N_PEROUT and fix the indexing to
the perout array.

Fixes: cf99c1dd7b77 ("igb: move PEROUT and EXTTS isr logic to separate functions")
Reported-by: Matt Corallo <ntp-lists@mattcorallo.com>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20230213185822.3960072-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6816,7 +6816,7 @@ static void igb_perout(struct igb_adapte
 	struct timespec64 ts;
 	u32 tsauxc;
 
-	if (pin < 0 || pin >= IGB_N_PEROUT)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	spin_lock(&adapter->tmreg_lock);
@@ -6824,7 +6824,7 @@ static void igb_perout(struct igb_adapte
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = timespec64_to_ns(&adapter->perout[pin].period);
+		s64 ns = timespec64_to_ns(&adapter->perout[tsintr_tt].period);
 		u32 systiml, systimh, level_mask, level, rem;
 		u64 systim, now;
 
@@ -6872,8 +6872,8 @@ static void igb_perout(struct igb_adapte
 		ts.tv_nsec = (u32)systim;
 		ts.tv_sec  = ((u32)(systim >> 32)) & 0xFF;
 	} else {
-		ts = timespec64_add(adapter->perout[pin].start,
-				    adapter->perout[pin].period);
+		ts = timespec64_add(adapter->perout[tsintr_tt].start,
+				    adapter->perout[tsintr_tt].period);
 	}
 
 	/* u32 conversion of tv_sec is safe until y2106 */
@@ -6882,7 +6882,7 @@ static void igb_perout(struct igb_adapte
 	tsauxc = rd32(E1000_TSAUXC);
 	tsauxc |= TSAUXC_EN_TT0;
 	wr32(E1000_TSAUXC, tsauxc);
-	adapter->perout[pin].start = ts;
+	adapter->perout[tsintr_tt].start = ts;
 
 	spin_unlock(&adapter->tmreg_lock);
 }
@@ -6896,7 +6896,7 @@ static void igb_extts(struct igb_adapter
 	struct ptp_clock_event event;
 	struct timespec64 ts;
 
-	if (pin < 0 || pin >= IGB_N_EXTTS)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	if (hw->mac.type == e1000_82580 ||



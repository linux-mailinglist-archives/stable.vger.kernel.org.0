Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99AE595181
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiHPE6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiHPE5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5ECBC129;
        Mon, 15 Aug 2022 13:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92B16B8113E;
        Mon, 15 Aug 2022 20:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0151C433C1;
        Mon, 15 Aug 2022 20:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596691;
        bh=CcEXs1wOl50usw5N4AKXfF+Uu0otjqaJAqH0q47J1p8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7N3PWsg/zFaMgGxd8wVin35jXF6Cw7cwzKqIJvmRLSWbQ9IAPb3cZTSV+o/DkKi8
         Xr9n4ITX2xIBUvY6TKPdD5I+GpFTmxY2MTDX1rOfJy5uHtDwAJnXnjZXqk9btcNicI
         pudnqj+F9BVBLaIjR/qPBo62apEemqbLIEhC5SSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 1153/1157] net: dsa: felix: fix min gate len calculation for tc when its first gate is closed
Date:   Mon, 15 Aug 2022 20:08:29 +0200
Message-Id: <20220815180526.658433843@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 7e4babffa6f340a74c820d44d44d16511e666424 upstream.

min_gate_len[tc] is supposed to track the shortest interval of
continuously open gates for a traffic class. For example, in the
following case:

TC 76543210

t0 00000001b 200000 ns
t1 00000010b 200000 ns

min_gate_len[0] and min_gate_len[1] should be 200000, while
min_gate_len[2-7] should be 0.

However what happens is that min_gate_len[0] is 200000, but
min_gate_len[1] ends up being 0 (despite gate_len[1] being 200000 at the
point where the logic detects the gate close event for TC 1).

The problem is that the code considers a "gate close" event whenever it
sees that there is a 0 for that TC (essentially it's level rather than
edge triggered). By doing that, any time a gate is seen as closed
without having been open prior, gate_len, which is 0, will be written
into min_gate_len. Once min_gate_len becomes 0, it's impossible for it
to track anything higher than that (the length of actually open
intervals).

To fix this, we make the writing to min_gate_len[tc] be edge-triggered,
which avoids writes for gates that are closed in consecutive intervals.
However what this does is it makes us need to special-case the
permanently closed gates at the end.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220804202817.1677572-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1136,6 +1136,7 @@ static void vsc9959_tas_min_gate_lengths
 {
 	struct tc_taprio_sched_entry *entry;
 	u64 gate_len[OCELOT_NUM_TC];
+	u8 gates_ever_opened = 0;
 	int tc, i, n;
 
 	/* Initialize arrays */
@@ -1163,16 +1164,28 @@ static void vsc9959_tas_min_gate_lengths
 		for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
 			if (entry->gate_mask & BIT(tc)) {
 				gate_len[tc] += entry->interval;
+				gates_ever_opened |= BIT(tc);
 			} else {
 				/* Gate closes now, record a potential new
 				 * minimum and reinitialize length
 				 */
-				if (min_gate_len[tc] > gate_len[tc])
+				if (min_gate_len[tc] > gate_len[tc] &&
+				    gate_len[tc])
 					min_gate_len[tc] = gate_len[tc];
 				gate_len[tc] = 0;
 			}
 		}
 	}
+
+	/* min_gate_len[tc] actually tracks minimum *open* gate time, so for
+	 * permanently closed gates, min_gate_len[tc] will still be U64_MAX.
+	 * Therefore they are currently indistinguishable from permanently
+	 * open gates. Overwrite the gate len with 0 when we know they're
+	 * actually permanently closed, i.e. after the loop above.
+	 */
+	for (tc = 0; tc < OCELOT_NUM_TC; tc++)
+		if (!(gates_ever_opened & BIT(tc)))
+			min_gate_len[tc] = 0;
 }
 
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the



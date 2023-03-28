Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603076CC2CF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjC1OtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjC1Osk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D56CE04D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE0B6CE1DA4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD50FC433EF;
        Tue, 28 Mar 2023 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014865;
        bh=7lP/VRoNWVcy1jqaDY8c6O3gRN6aTI3Jrz5tmN3v1cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBdDR2fvulAvCzodj5Xf3E25Dw4xgTulbygzN++UbjPBLuAZ+KdABPBiCentOln0P
         4EncmL3C2eEEgCAvGhxkm69Vlzrf3F9ezMbAhHVdBtYmC9QIsfL2InYpY8SdlRt0+G
         L6zUDWzBwfMadsIpqRc5FjYW8X3B0FtHmjz8J8i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 081/240] net: mscc: ocelot: fix stats region batching
Date:   Tue, 28 Mar 2023 16:40:44 +0200
Message-Id: <20230328142623.153789306@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6acc72a43eac78a309160d0a7512bbc59bcdd757 ]

The blamed commit changed struct ocelot_stat_layout :: "u32 offset" to
"u32 reg".

However, "u32 reg" is not quite a register address, but an enum
ocelot_reg, which in itself encodes an enum ocelot_target target in the
upper bits, and an index into the ocelot->map[target][] array in the
lower bits.

So, whereas the previous code comparison between stats_layout[i].offset
and last + 1 was correct (because those "offsets" at the time were
32-bit relative addresses), the new code, comparing layout[i].reg to
last + 4 is not correct, because the "reg" here is an enum/index, not an
actual register address.

What we want to compare are indeed register addresses, but to do that,
we need to actually go through the same motions as
__ocelot_bulk_read_ix() itself.

With this bug, all statistics counters are deemed by
ocelot_prepare_stats_regions() as constituting their own region.
(Truncated) log on VSC9959 (Felix) below (prints added by me):

Before:

region of 1 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x001]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x002]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x041]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x042]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x081]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x0ac]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x100]
region of 1 contiguous counters starting with SYS:STAT:CNT[0x101]
...
region of 1 contiguous counters starting with SYS:STAT:CNT[0x111]

After:

region of 67 contiguous counters starting with SYS:STAT:CNT[0x000]
region of 45 contiguous counters starting with SYS:STAT:CNT[0x080]
region of 18 contiguous counters starting with SYS:STAT:CNT[0x100]

Since commit d87b1c08f38a ("net: mscc: ocelot: use bulk reads for
stats") intended bulking as a performance improvement, and since now,
with trivial-sized regions, performance is even worse than without
bulking at all, this could easily qualify as a performance regression.

Fixes: d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 1478c3b21af15..cb196775489e2 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -611,7 +611,8 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 		if (!ocelot_stats_layout[i].reg)
 			continue;
 
-		if (region && ocelot_stats_layout[i].reg == last + 4) {
+		if (region && ocelot->map[SYS][ocelot_stats_layout[i].reg & REG_MASK] ==
+		    ocelot->map[SYS][last & REG_MASK] + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
-- 
2.39.2




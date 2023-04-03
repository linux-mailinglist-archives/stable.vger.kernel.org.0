Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED416D4939
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjDCOf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjDCOf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A72D49F9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2EF961E79
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014CFC433D2;
        Mon,  3 Apr 2023 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532555;
        bh=XKXMr5lMReRr8Ngfu/aYoDSGCqTAZ0Ikk8Ooz28fQj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsCUaWV4o65sz+/xDU20I17CATj+F2xk7I8piIHtJ5c9SMcPhsHT5PUoeFsvYgYJU
         gDRdv/pLUnhuRvBtM820GV44rIV0ztqU4ksnqCVDZNxHeaj4/2IZVL6/QH81c7Fs7H
         ZylsMmtIL32NfRgEydCFgTahcQwA9+WV00EC7SB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/181] net: mscc: ocelot: fix stats region batching
Date:   Mon,  3 Apr 2023 16:07:43 +0200
Message-Id: <20230403140416.078587480@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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
index dbd20b125ceaf..0066219bb0e89 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -392,7 +392,8 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 		if (!ocelot->stats_layout[i].reg)
 			continue;
 
-		if (region && ocelot->stats_layout[i].reg == last + 4) {
+		if (region && ocelot->map[SYS][ocelot->stats_layout[i].reg & REG_MASK] ==
+		    ocelot->map[SYS][last & REG_MASK] + 4) {
 			region->count++;
 		} else {
 			region = devm_kzalloc(ocelot->dev, sizeof(*region),
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761245290A6
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346422AbiEPTyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348163AbiEPTwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091534552C;
        Mon, 16 May 2022 12:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A8F3B81607;
        Mon, 16 May 2022 19:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70487C385AA;
        Mon, 16 May 2022 19:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730492;
        bh=/Oks+nr+JGxMqRqVqWtXxyA40Fk18XVRbWUKGWN7zWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzbCgZ1uEg6tJNziPELf3qNQPZrmbK0pMzbWlkTMUSNdJ3t0pn/3P/9vZDK8Axmzr
         msDxk2jFp0k5/xt1SXO2HKOgnthJQTr50IWFp7jzuSJ4Fp/89bnjsQEOWJMNJYJ8I/
         tcR/ADi+TFvmAz7ZkUpDEMckjX0MM3nqyOpwQbwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/102] net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
Date:   Mon, 16 May 2022 21:35:43 +0200
Message-Id: <20220516193624.262148362@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 93a8417088ea570b5721d2b526337a2d3aed9fa3 ]

Given the following order of operations:

(1) we add filter A using tc-flower
(2) we send a packet that matches it
(3) we read the filter's statistics to find a hit count of 1
(4) we add a second filter B with a higher preference than A, and A
    moves one position to the right to make room in the TCAM for it
(5) we send another packet, and this matches the second filter B
(6) we read the filter statistics again.

When this happens, the hit count of filter A is 2 and of filter B is 1,
despite a single packet having matched each filter.

Furthermore, in an alternate history, reading the filter stats a second
time between steps (3) and (4) makes the hit count of filter A remain at
1 after step (6), as expected.

The reason why this happens has to do with the filter->stats.pkts field,
which is written to hardware through the call path below:

               vcap_entry_set
               /      |      \
              /       |       \
             /        |        \
            /         |         \
es0_entry_set   is1_entry_set   is2_entry_set
            \         |         /
             \        |        /
              \       |       /
        vcap_data_set(data.counter, ...)

The primary role of filter->stats.pkts is to transport the filter hit
counters from the last readout all the way from vcap_entry_get() ->
ocelot_vcap_filter_stats_update() -> ocelot_cls_flower_stats().
The reason why vcap_entry_set() writes it to hardware is so that the
counters (saturating and having a limited bit width) are cleared
after each user space readout.

The writing of filter->stats.pkts to hardware during the TCAM entry
movement procedure is an unintentional consequence of the code design,
because the hit count isn't up to date at this point.

So at step (4), when filter A is moved by ocelot_vcap_filter_add() to
make room for filter B, the hardware hit count is 0 (no packet matched
on it in the meantime), but filter->stats.pkts is 1, because the last
readout saw the earlier packet. The movement procedure programs the old
hit count back to hardware, so this creates the impression to user space
that more packets have been matched than they really were.

The bug can be seen when running the gact_drop_and_ok_test() from the
tc_actions.sh selftest.

Fix the issue by reading back the hit count to tmp->stats.pkts before
migrating the VCAP filter. Sure, this is a best-effort technique, since
the packets that hit the rule between vcap_entry_get() and
vcap_entry_set() won't be counted, but at least it allows the counters
to be reliably used for selftests where the traffic is under control.

The vcap_entry_get() name is a bit unintuitive, but it only reads back
the counter portion of the TCAM entry, not the entire entry.

The index from which we retrieve the counter is also a bit unintuitive
(i - 1 during add, i + 1 during del), but this is the way in which TCAM
entry movement works. The "entry index" isn't a stored integer for a
TCAM filter, instead it is dynamically computed by
ocelot_vcap_block_get_filter_index() based on the entry's position in
the &block->rules list. That position (as well as block->count) is
automatically updated by ocelot_vcap_filter_add_to_block() on add, and
by ocelot_vcap_block_remove_filter() on del. So "i" is the new filter
index, and "i - 1" or "i + 1" respectively are the old addresses of that
TCAM entry (we only support installing/deleting one filter at a time).

Fixes: b596229448dd ("net: mscc: ocelot: Add support for tcam")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index c01cbc4f7a1a..732a4ef22518 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1152,6 +1152,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i - 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
@@ -1210,6 +1212,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i + 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
-- 
2.35.1




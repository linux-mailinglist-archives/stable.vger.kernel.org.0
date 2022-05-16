Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A814852911B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347269AbiEPUGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349105AbiEPT7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C3840937;
        Mon, 16 May 2022 12:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D723FB81627;
        Mon, 16 May 2022 19:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2A5C36AE7;
        Mon, 16 May 2022 19:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730800;
        bh=YHCcsAPo3HXhqClBwVSBvvvHd29gyEvqoT/UiYF/VYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQzwGL7w/VWLKM3hGG/HqJbho8iFrgDYXiy4VRUMXm2bWiKosf+AY7nrB0ETGtef+
         MAhaYRLETGmvX/nDmDHkCbm2baquaCPFtsHr+CM00+a0pKiunJIlIRjd+gETijXacK
         mT6E6rOvtVVHqrP3AALR2ziOMZqtn7fZ2cCNeQ1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 010/114] net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
Date:   Mon, 16 May 2022 21:35:44 +0200
Message-Id: <20220516193625.793332837@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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
index 6c643936c675..f159726788ba 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1181,6 +1181,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i - 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
@@ -1239,6 +1241,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i + 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFAC529093
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346838AbiEPUMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350558AbiEPUBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84234A931;
        Mon, 16 May 2022 12:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88FADB81613;
        Mon, 16 May 2022 19:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80B8C385AA;
        Mon, 16 May 2022 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730919;
        bh=8F2+mQuyKJsVZ+YRZ5vP0LDsn3RVwXnNtAs05DEbjno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAAyZOnK5AsOW70mVs1STXGYyHWK5cd3Jr45eKIGzNB2RssBpey0ZvAaglPYZDOnx
         0lPkeensYLB2xOq1sxrrSlLrjqyfmlzwUoFN3k0Zo6eDgpeUCUtZlcH5W1padPt9rw
         LtXs51LL3HhbrYM140tN+nb2dAeW3bx0oGynlGSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 008/114] net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
Date:   Mon, 16 May 2022 21:35:42 +0200
Message-Id: <20220516193625.736092657@linuxfoundation.org>
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

[ Upstream commit 6741e11880003e35802d78cc58035057934f4dab ]

The VCAP IS2 TCAM is looked up twice per packet, and each filter can be
configured to only match during the first, second lookup, or both, or
none.

The blamed commit wrote the code for making VCAP IS2 filters match only
on the given lookup. But right below that code, there was another line
that explicitly made the lookup a "don't care", and this is overwriting
the lookup we've selected. So the code had no effect.

Some of the more noticeable effects of having filters match on both
lookups:

- in "tc -s filter show dev swp0 ingress", we see each packet matching a
  VCAP IS2 filter counted twice. This throws off scripts such as
  tools/testing/selftests/net/forwarding/tc_actions.sh and makes them
  fail.

- a "tc-drop" action offloaded to VCAP IS2 needs a policer as well,
  because once the CPU port becomes a member of the destination port
  mask of a packet, nothing removes it, not even a PERMIT/DENY mask mode
  with a port mask of 0. But VCAP IS2 rules with the POLICE_ENA bit in
  the action vector can only appear in the first lookup. What happens
  when a filter matches both lookups is that the action vector is
  combined, and this makes the POLICE_ENA bit ineffective, since the
  last lookup in which it has appeared is the second one. In other
  words, "tc-drop" actions do not drop packets for the CPU port, dropped
  packets are still seen by software unless there was an FDB entry that
  directed those packets to some other place different from the CPU.

The last bit used to work, because in the initial commit b596229448dd
("net: mscc: ocelot: Add support for tcam"), we were writing the FIRST
field of the VCAP IS2 half key with a 1, not with a "don't care".
The change to "don't care" was made inadvertently by me in commit
c1c3993edb7c ("net: mscc: ocelot: generalize existing code for VCAP"),
which I just realized, and which needs a separate fix from this one,
for "stable" kernels that lack the commit blamed below.

Fixes: 226e9cd82a96 ("net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index e650afef12af..6c643936c675 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -373,7 +373,6 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
-	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
-- 
2.35.1




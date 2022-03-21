Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04AF4E2949
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348778AbiCUODw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349256AbiCUODe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:03:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D8917A5AA;
        Mon, 21 Mar 2022 07:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D74B816DA;
        Mon, 21 Mar 2022 14:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD68C340E8;
        Mon, 21 Mar 2022 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871239;
        bh=ncPSTEN0x7hwAkl3eUC7dRPKqq34LJzaKAZd0CZZJX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qir9TBe/AakRHXJ24Q5earUGLvz24Ho7Qs5nTKFpKHCKp4vnM5ta296Vm0RNpZcvs
         qmZ8xsHOqZHVhguipNBgLZ7oUyP9tzwEUvLl1eTzHO56gEkdW/baWzCM0MjiLLaIek
         jwXZPlYF1TarFPZAksGk+20hcL4tMpBGahzTIFK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/32] net: mscc: ocelot: fix backwards compatibility with single-chain tc-flower offload
Date:   Mon, 21 Mar 2022 14:52:59 +0100
Message-Id: <20220321133221.234099431@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133220.559554263@linuxfoundation.org>
References: <20220321133220.559554263@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8e0341aefcc9133f3f48683873284b169581315b ]

ACL rules can be offloaded to VCAP IS2 either through chain 0, or, since
the blamed commit, through a chain index whose number encodes a specific
PAG (Policy Action Group) and lookup number.

The chain number is translated through ocelot_chain_to_pag() into a PAG,
and through ocelot_chain_to_lookup() into a lookup number.

The problem with the blamed commit is that the above 2 functions don't
have special treatment for chain 0. So ocelot_chain_to_pag(0) returns
filter->pag = 224, which is in fact -32, but the "pag" field is an u8.

So we end up programming the hardware with VCAP IS2 entries having a PAG
of 224. But the way in which the PAG works is that it defines a subset
of VCAP IS2 filters which should match on a packet. The default PAG is
0, and previous VCAP IS1 rules (which we offload using 'goto') can
modify it. So basically, we are installing filters with a PAG on which
no packet will ever match. This is the hardware equivalent of adding
filters to a chain which has no 'goto' to it.

Restore the previous functionality by making ACL filters offloaded to
chain 0 go to PAG 0 and lookup number 0. The choice of PAG is clearly
correct, but the choice of lookup number isn't "as before" (which was to
leave the lookup a "don't care"). However, lookup 0 should be fine,
since even though there are ACL actions (policers) which have a
requirement to be used in a specific lookup, that lookup is 0.

Fixes: 226e9cd82a96 ("net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220316192117.2568261-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index afa062c5f82d..f1323af99b0c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -54,6 +54,12 @@ static int ocelot_chain_to_block(int chain, bool ingress)
  */
 static int ocelot_chain_to_lookup(int chain)
 {
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
 	return (chain / VCAP_LOOKUP) % 10;
 }
 
@@ -62,7 +68,15 @@ static int ocelot_chain_to_lookup(int chain)
  */
 static int ocelot_chain_to_pag(int chain)
 {
-	int lookup = ocelot_chain_to_lookup(chain);
+	int lookup;
+
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
+	lookup = ocelot_chain_to_lookup(chain);
 
 	/* calculate PAG value as chain index relative to the first PAG */
 	return chain - VCAP_IS2_CHAIN(lookup, 0);
-- 
2.34.1




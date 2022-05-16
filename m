Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B300F528FBB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348493AbiEPUGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348306AbiEPT6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528C2434BC;
        Mon, 16 May 2022 12:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C158DB81614;
        Mon, 16 May 2022 19:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19399C385AA;
        Mon, 16 May 2022 19:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730625;
        bh=VbcijCb6Rp+Jf2r/UgG7n+MJXK5apoNhh0m1772GtGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgaJIu1AQLXNb2bb+4w3Ba57HwGr6J1Ni4YGF/dNU+qobSyvYMy3OhRt9VnhRwehY
         yL0E6+N+wY//Y5gGaOx0k/rETAe7OmAuKVqPA4oRqYcQY7PyYuWA+gQKBwgHdl+XEC
         YxJr3XkNwbkCAtFrIfK4ehtMN918qqREERL/9nMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/102] net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
Date:   Mon, 16 May 2022 21:35:42 +0200
Message-Id: <20220516193624.233592876@linuxfoundation.org>
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

[ Upstream commit 477d2b91623e682e9a8126ea92acb8f684969cc7 ]

Once the CPU port was added to the destination port mask of a packet, it
can never be cleared, so even packets marked as dropped by the MASK_MODE
of a VCAP IS2 filter will still reach it. This is why we need the
OCELOT_POLICER_DISCARD to "kill dropped packets dead" and make software
stop seeing them.

We disallow policer rules from being put on any other chain than the one
for the first lookup, but we don't do this for "drop" rules, although we
should. This change is merely ascertaining that the rules dont't
(completely) work and letting the user know.

The blamed commit is the one that introduced the multi-chain architecture
in ocelot. Prior to that, we should have always offloaded the filters to
VCAP IS2 lookup 0, where they did work.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index f1323af99b0c..a3a5ad5dbb0e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -206,9 +206,10 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_TRAP:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Trap action can only be offloaded to VCAP IS2");
+						   "Trap action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
-- 
2.35.1




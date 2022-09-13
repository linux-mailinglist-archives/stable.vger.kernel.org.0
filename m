Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0CD5B710C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiIMOhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiIMOgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:36:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB316556E;
        Tue, 13 Sep 2022 07:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C498A6148A;
        Tue, 13 Sep 2022 14:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6930C433C1;
        Tue, 13 Sep 2022 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078822;
        bh=fty3+JGxEdsX47dqE33fURR/AhxAKDxvqljQ8sVHqTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in86mumssDRm5cluK1DIjjHSUA+Ts1Ox7mu0rLB1G9f8b0qBsN/Hq3rJ+us231IxE
         axgAcL0yBV+4C9to0Wv4Xhwmb1MlCw5R0YiMlrV5YES+jawVu5aKxf56Zc3eMTSULi
         9T8xf6BJG/VQWmfiS8TguEXA+2lk8nXDozCzBNYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Leadbeater <dgl@dgl.cx>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/121] netfilter: nf_conntrack_irc: Fix forged IP logic
Date:   Tue, 13 Sep 2022 16:04:20 +0200
Message-Id: <20220913140400.332108984@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: David Leadbeater <dgl@dgl.cx>

[ Upstream commit 0efe125cfb99e6773a7434f3463f7c2fa28f3a43 ]

Ensure the match happens in the right direction, previously the
destination used was the server, not the NAT host, as the comment
shows the code intended.

Additionally nf_nat_irc uses port 0 as a signal and there's no valid way
it can appear in a DCC message, so consider port 0 also forged.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: David Leadbeater <dgl@dgl.cx>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_irc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 08ee4e760a3d2..18b90e334b5bd 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -188,8 +188,9 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
 			tuple = &ct->tuplehash[dir].tuple;
-			if (tuple->src.u3.ip != dcc_ip &&
-			    tuple->dst.u3.ip != dcc_ip) {
+			if ((tuple->src.u3.ip != dcc_ip &&
+			     ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) ||
+			    dcc_port == 0) {
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
-- 
2.35.1




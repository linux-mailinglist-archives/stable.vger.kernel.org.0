Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203AC63DF92
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiK3Ssq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiK3Ss1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9617F9B7B3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 339C861D82
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45532C433D6;
        Wed, 30 Nov 2022 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834104;
        bh=kGdTftkyRf/A7l8ShioqwzSVWTIsZffc9+QvzwfEPB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmafrW1cK3pFiyRghKgDTVo97k2q4J28EwmgDORvxCSsfrjGv3o9SynFj7hkCmcwt
         K78woy/0hPg6JZMh9FDVNsBGmGENYVaeg7LthN42P1+FkJnyU1SdRAfYrRo/gIBPTD
         hD7d54rcEkGnuV0jpZ3qLInUmVxEgwOJYyNFvND4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chad Monroe <chad.monroe@smartrg.com>,
        Felix Fietkau <nbd@nbd.name>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 130/289] netfilter: flowtable_offload: add missing locking
Date:   Wed, 30 Nov 2022 19:21:55 +0100
Message-Id: <20221130180547.086434328@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bcd9e3c1656d0f7dd9743598c65c3ae24efb38d0 ]

nf_flow_table_block_setup and the driver TC_SETUP_FT call can modify the flow
block cb list while they are being traversed elsewhere, causing a crash.
Add a write lock around the calls to protect readers

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Chad Monroe <chad.monroe@smartrg.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b04645ced89b..00b522890d77 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1098,6 +1098,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
+	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -1112,6 +1113,7 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
+	up_write(&flowtable->flow_block_lock);
 
 	return err;
 }
@@ -1168,7 +1170,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
+	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
+	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
-- 
2.35.1




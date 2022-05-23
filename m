Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EBD53188A
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbiEWRie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241679AbiEWRdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:33:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78817CB41;
        Mon, 23 May 2022 10:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4BDB608C0;
        Mon, 23 May 2022 17:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95D3C385A9;
        Mon, 23 May 2022 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326883;
        bh=DpiMKSUnLxhXsBTF7zVyd2dd1Go1TMiq4kSzb6WHBI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PyRa1Xm9bD6UbOsVhKNDxgz19oMqc17HO/XFR6v0/lmm2ixms0aaDldwEA8GklPV4
         Dqo8Cs+ITeUOXS7GcO4xWJ37qnG0qr6IT6n+4Z45JRne/3PMG0Fut0nhPK5Pd77Dvw
         hZvAEfs0ZF4rQkuUtE2OvJWG1t94mS924Vlwg6n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 088/158] netfilter: nft_flow_offload: fix offload with pppoe + vlan
Date:   Mon, 23 May 2022 19:04:05 +0200
Message-Id: <20220523165845.748878507@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2456074935003b66c40f78df6adfc722435d43ea ]

When running a combination of PPPoE on top of a VLAN, we need to set
info->outdev to the PPPoE device, otherwise PPPoE encap is skipped
during software offload.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index dd824193c920..12145a80ef03 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -123,7 +123,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			info->outdev = path->dev;
+			if (!info->outdev)
+				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-- 
2.35.1




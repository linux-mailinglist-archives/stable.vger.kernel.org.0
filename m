Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF7753162D
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiEWRaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241755AbiEWR1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFFE7628D;
        Mon, 23 May 2022 10:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B003B811FB;
        Mon, 23 May 2022 17:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80420C385A9;
        Mon, 23 May 2022 17:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326514;
        bh=YZE+m7ONmE5iuJpKWbbbuCCWQu4aPJghpauoTYok9a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxYddLiix41UMmpOeqB5Ctkybu0wbyQLUxPwWWeXkwbl1C/v52xxOUZzMQZwFJnit
         5B261oyua3fKARzq51sHUM9j9ke4H/WUyNRp4uKcQ/fFUAW+I20tDohsKgMQMY2GHy
         Fv5JegohiEcsIgVUKC1zsHoDbku+BBLb6DnyNZrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/132] net: fix dev_fill_forward_path with pppoe + bridge
Date:   Mon, 23 May 2022 19:04:46 +0200
Message-Id: <20220523165835.897101335@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

[ Upstream commit cf2df74e202d81b09f09d84c2d8903e0e87e9274 ]

When calling dev_fill_forward_path on a pppoe device, the provided destination
address is invalid. In order for the bridge fdb lookup to succeed, the pppoe
code needs to update ctx->daddr to the correct value.
Fix this by storing the address inside struct net_device_path_ctx

Fixes: f6efc675c9dd ("net: ppp: resolve forwarding path for bridge pppoe devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c   | 1 +
 include/linux/netdevice.h | 2 +-
 net/core/dev.c            | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 3619520340b7..e172743948ed 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -988,6 +988,7 @@ static int pppoe_fill_forward_path(struct net_device_path_ctx *ctx,
 	path->encap.proto = htons(ETH_P_PPP_SES);
 	path->encap.id = be16_to_cpu(po->num);
 	memcpy(path->encap.h_dest, po->pppoe_pa.remote, ETH_ALEN);
+	memcpy(ctx->daddr, po->pppoe_pa.remote, ETH_ALEN);
 	path->dev = ctx->dev;
 	ctx->dev = dev;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 62ff09467776..39f1893ecac0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,7 +887,7 @@ struct net_device_path_stack {
 
 struct net_device_path_ctx {
 	const struct net_device *dev;
-	const u8		*daddr;
+	u8			daddr[ETH_ALEN];
 
 	int			num_vlans;
 	struct {
diff --git a/net/core/dev.c b/net/core/dev.c
index 804aba2228c2..5907212c00f3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -741,11 +741,11 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 	const struct net_device *last_dev;
 	struct net_device_path_ctx ctx = {
 		.dev	= dev,
-		.daddr	= daddr,
 	};
 	struct net_device_path *path;
 	int ret = 0;
 
+	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
 	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
 		last_dev = ctx.dev;
-- 
2.35.1




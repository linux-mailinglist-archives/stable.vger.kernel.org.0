Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E899C66C5AA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjAPQIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjAPQIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DCA14E8E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43B80B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956EEC433F0;
        Mon, 16 Jan 2023 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885150;
        bh=n9TnI0pMKQubFUKIHW73Iy6//zMxNWuK11DbxStatFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d59vFPdAlpYV1qW652WNtAZqceEOupLwxxztoxSRJgN607CtGHXatAuU8n9uo5/SD
         Jpz7/OBs6t7t5g+Urx+/47N7AF1xylVhxtJAa4mZdUjvC4K6s4QpFHyClqZbO0RRwC
         dS9+/0lTxDChsnIeRo1u0cuZTWvw/4wUL20auU7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gavin Li <gavinl@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 69/86] net/mlx5e: Dont support encap rules with gbp option
Date:   Mon, 16 Jan 2023 16:51:43 +0100
Message-Id: <20230116154749.929606526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit d515d63cae2cd186acf40deaa8ef33067bb7f637 ]

Previously, encap rules with gbp option would be offloaded by mistake but
driver does not support gbp option offload.

To fix this issue, check if the encap rule has gbp option and don't
offload the rule

Fixes: d8f9dfae49ce ("net: sched: allow flower to match vxlan options")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 4267f3a1059e..78b1a6ddd967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -88,6 +88,8 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	struct udphdr *udp = (struct udphdr *)(buf);
 	struct vxlanhdr *vxh;
 
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
 
-- 
2.35.1




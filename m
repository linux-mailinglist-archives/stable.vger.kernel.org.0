Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D3566C506
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjAPQAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjAPQAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C472384A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C29F61041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4723C433D2;
        Mon, 16 Jan 2023 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884838;
        bh=sTaXPOaojZDW4YNXnTZJ16OOWJgW6/SPpMTNC1sc81k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aK3NxrtwQmk6S0aNXU/Kso4pYwHGQjli8LB5uUwCJgKoBiaJrSjoetkyRGS2FJGpx
         eRYu1pCOzMHbCKPQ3iTJ/BBAj8YffnObGlFkRMNXaILThjs2831u3TmhdiqQE5ZeEW
         8Re4JxUAwDlTgtHTleuGMyEeQgYNPdoSSiuXpt+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gavin Li <gavinl@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/183] net/mlx5e: Dont support encap rules with gbp option
Date:   Mon, 16 Jan 2023 16:51:21 +0100
Message-Id: <20230116154809.980985478@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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
index fd07c4cbfd1d..1f62c702b625 100644
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




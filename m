Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0513643BE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhDSNV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241239AbhDSNUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FED6613C3;
        Mon, 19 Apr 2021 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838165;
        bh=yat5p+f9zHvoy3UO0fYv0ohWVxxKrhqeMlFexDW1ASE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzUM4TB74RvFTOR/fM2j5p9DSj6VFCkGa1ZQlghXYNKUkAbfC5kxEqLdoMx4/e75v
         wUzkBi7FqNcaJPVtOsrx9QdvBt0icTmzvObfipz2tZMef3LnBF/VOUs0G1g1nW01lF
         JQJ/LW9ZKDz8iVGZ9FahFCTbnQSo0nQRQnAOOkJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 066/103] net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta
Date:   Mon, 19 Apr 2021 15:06:17 +0200
Message-Id: <20210419130530.084359107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

commit e3e0f9b279705154b951d579dc3d8b7041710e24 upstream.

In the nft_offload there is the mate flow_dissector with no
ingress_ifindex but with ingress_iftype that only be used
in the software. So if the mask of ingress_ifindex in meta is
0, this meta check should be bypass.

Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2196,6 +2196,9 @@ static int mlx5e_flower_parse_meta(struc
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EOPNOTSUPP;



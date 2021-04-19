Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFFF3642F0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhDSNMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239861AbhDSNL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260C7613AC;
        Mon, 19 Apr 2021 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837857;
        bh=+pUJBqWITYbTteiuYbpBDNZTAfS7rTN6O7flEe2GnRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iC92Jh/RZmT2xtnZDhPaXiZYDtMPZKjZktDHS143CefbnABNA+OZ7UAEnRjzmkYbA
         Cs1Sc6QLMlv/HzkT7Ijy6BGPrVUgi40c6P4HJdAh2B4N+Gbgh4WRGqCKRdCJSqIGAB
         f2Bu3VDQHAHAvHLfLBe3f9ShDUPW4DZxl8A/9vHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.11 080/122] net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta
Date:   Mon, 19 Apr 2021 15:06:00 +0200
Message-Id: <20210419130532.886968440@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
@@ -2194,6 +2194,9 @@ static int mlx5e_flower_parse_meta(struc
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EOPNOTSUPP;



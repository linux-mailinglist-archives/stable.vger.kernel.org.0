Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E6C469DDE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388481AbhLFPdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44126 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348235AbhLFP3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:29:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE4DA6132B;
        Mon,  6 Dec 2021 15:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B07C34900;
        Mon,  6 Dec 2021 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804333;
        bh=Kp9J9dmlUCxztqb2eJIHK1KhzRDJ/2nD5tfaIBmtgeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzScaLk9Rz5jTXBk78MXYKjux9R4YUjNUCO8APh9mWnJ8XmZHBpasTxA+2K+JzqOi
         uHIDpGqqa3jOKgWSzA+2zE0zKjHjjxw1OtRszPHCoUNIys2acZfJwIPnyR31jPPq3p
         YEjnhSE624HtnwHuU/FBauJ8EqtQLsC3LXTc2LlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 110/207] net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
Date:   Mon,  6 Dec 2021 15:56:04 +0100
Message-Id: <20211206145614.053882829@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

commit c65d638ab39034cbaa36773b980d28106cfc81fa upstream.

Current code wrongly uses the skb->protocol field which reflects the
outer l3 protocol to set the inner l3 type in Software Parser (SWP)
fields settings in the ethernet segment (eseg) in flows where inner
l3 exists like in Vxlan over ESP flow, the above method wrongly use
the outer protocol type instead of the inner one. thus breaking cases
where inner and outer headers have different protocols.

Fix by setting the inner l3 type in SWP according to the inner l3 ip
header version.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -191,7 +191,7 @@ static void mlx5e_ipsec_set_swp(struct s
 			eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
 			eseg->swp_inner_l4_offset =
 				(skb->csum_start + skb->head - skb->data) / 2;
-			if (skb->protocol == htons(ETH_P_IPV6))
+			if (inner_ip_hdr(skb)->version == 6)
 				eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
 			break;
 		default:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C9076E0C
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbfGZP2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387941AbfGZP2x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A2722CBF;
        Fri, 26 Jul 2019 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154932;
        bh=9cCUXLDKRsxfDMoR6KEmOnfyTw5M6dYipV/GNd1btkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf3bN0vu5xuzt5bVVqMIAtZ0WMtY6r9Xo0HU9LsE5pQRiGQey+0WBGOFHtQOkeLvL
         uo0PRtuqsYTGcih5SJrB26ONNCGg5yFji/NALUACoVgjsrOpH9f+0jo44ykpXXSCPR
         aPoGYySzCITH6G3P3ySRxU5SFW9XEfUJjXzoa5RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 39/66] net/mlx5e: Fix port tunnel GRE entropy control
Date:   Fri, 26 Jul 2019 17:24:38 +0200
Message-Id: <20190726152306.249386182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit 914adbb1bcf89478ac138318d28b302704564d59 ]

GRE entropy calculation is a single bit per card, and not per port.
Force disable GRE entropy calculation upon the first GRE encap rule,
and release the force at the last GRE encap rule removal. This is done
per port.

Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port tunnel entropy calculation")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c |   23 ++---------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -98,27 +98,12 @@ static int mlx5_set_entropy(struct mlx5_
 	 */
 	if (entropy_flags.gre_calc_supported &&
 	    reformat_type == MLX5_REFORMAT_TYPE_L2_TO_NVGRE) {
-		/* Other applications may change the global FW entropy
-		 * calculations settings. Check that the current entropy value
-		 * is the negative of the updated value.
-		 */
-		if (entropy_flags.force_enabled &&
-		    enable == entropy_flags.gre_calc_enabled) {
-			mlx5_core_warn(tun_entropy->mdev,
-				       "Unexpected GRE entropy calc setting - expected %d",
-				       !entropy_flags.gre_calc_enabled);
-			return -EOPNOTSUPP;
-		}
-		err = mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev, enable,
-							 entropy_flags.force_supported);
+		if (!entropy_flags.force_supported)
+			return 0;
+		err = mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev,
+							 enable, !enable);
 		if (err)
 			return err;
-		/* if we turn on the entropy we don't need to force it anymore */
-		if (entropy_flags.force_supported && enable) {
-			err = mlx5_set_port_gre_tun_entropy_calc(tun_entropy->mdev, 1, 0);
-			if (err)
-				return err;
-		}
 	} else if (entropy_flags.calc_supported) {
 		/* Other applications may change the global FW entropy
 		 * calculations settings. Check that the current entropy value



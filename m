Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E34E4A9690
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358181AbiBDJ1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358193AbiBDJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7324BC0617AA;
        Fri,  4 Feb 2022 01:25:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E75CB615DC;
        Fri,  4 Feb 2022 09:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A73C004E1;
        Fri,  4 Feb 2022 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966735;
        bh=kwu8oyxPXneCOK+dXVuehjtiF0UAtSc5LbFz+5t6RLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8UKN91zEb0BizFocDNLkHdRENzV4POoXe3DKBmeLJBPD7PjvoNEfjk2WSYSaR5lj
         7TfjTqs9OZzMNSVZ3yNq5CAAQvadcZRPadxEpaAxX4dwvQYjwEKFJsPWS8Th/djzSA
         F7JR9nDoPzk4Un4Wl5Nn3Dlx74AOC7i0r1H4epok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 22/43] net/mlx5e: Dont treat small ceil values as unlimited in HTB offload
Date:   Fri,  4 Feb 2022 10:22:29 +0100
Message-Id: <20220204091917.898015347@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit 736dfe4e68b868829a1e89dfef4a44c1580d4478 upstream.

The hardware spec defines max_average_bw == 0 as "unlimited bandwidth".
max_average_bw is calculated as `ceil / BYTES_IN_MBIT`, which can become
0 when ceil is small, leading to an undesired effect of having no
bandwidth limit.

This commit fixes it by rounding up small values of ceil to 1 Mbit/s.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -569,7 +569,8 @@ static int mlx5e_htb_convert_rate(struct
 
 static void mlx5e_htb_convert_ceil(struct mlx5e_priv *priv, u64 ceil, u32 *max_average_bw)
 {
-	*max_average_bw = div_u64(ceil, BYTES_IN_MBIT);
+	/* Hardware treats 0 as "unlimited", set at least 1. */
+	*max_average_bw = max_t(u32, div_u64(ceil, BYTES_IN_MBIT), 1);
 
 	qos_dbg(priv->mdev, "Convert: ceil %llu -> max_average_bw %u\n",
 		ceil, *max_average_bw);



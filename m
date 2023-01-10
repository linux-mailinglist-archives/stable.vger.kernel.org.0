Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD19D664923
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239179AbjAJSSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbjAJSRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505F9CE0D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA02E6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD30EC433EF;
        Tue, 10 Jan 2023 18:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374564;
        bh=rmRuFYKa0h6SkxPZASmZn4NIO5CdSaMT25ermC6vWXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+Hg/sC9aQfwiBu7i87sJIGnwYEoJyHF52utPaGa/q+eWgOLQJxTx/qoPYRfwaq8S
         hdtJgDYKzudNocv2d97GR0jxo+thl6SL68Po7W7+Ya/25LVYkG/rsLXBpDz7Y6o/VA
         z+Q8JvlKoH9zgX1/dkRd0Tmels6M3onqskme6JWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/159] net/mlx5e: Fix RX reporter for XSK RQs
Date:   Tue, 10 Jan 2023 19:03:25 +0100
Message-Id: <20230110180020.131864518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit f8c18a5749cf917096f75dd59885b7a0fe9298ba ]

RX reporter mistakenly reads from the regular (inactive) RQ
when XSK RQ is active. Fix it here.

Fixes: 3db4c85cde7a ("net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 5f6f95ad6888..1ae15b8536a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -459,7 +459,11 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_health_reporter *reporter,
 		goto unlock;
 
 	for (i = 0; i < priv->channels.num; i++) {
-		struct mlx5e_rq *rq = &priv->channels.c[i]->rq;
+		struct mlx5e_channel *c = priv->channels.c[i];
+		struct mlx5e_rq *rq;
+
+		rq = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state) ?
+			&c->xskrq : &c->rq;
 
 		err = mlx5e_rx_reporter_build_diagnose_output(rq, fmsg);
 		if (err)
-- 
2.35.1




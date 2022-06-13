Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0831354886A
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357058AbiFMM61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354154AbiFMMzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116B3E0F7;
        Mon, 13 Jun 2022 04:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C76CEB80D31;
        Mon, 13 Jun 2022 11:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F59CC34114;
        Mon, 13 Jun 2022 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118978;
        bh=X6kkzVYVdB8A2ze+kclGHClxaeC5m6GxAOdQxN8LbtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSnJysYhI2p0e1UpV0C7WLFqT1lmD7weRQ4AYqoOmHn0d7nxE+Kyv7Cfc4lRdLK0b
         6n8r68e+TV8E/tL7QnCpOcVixKawN0uDUaFeXeThzfyZLLdLlRPjM8A+tdYexEdljw
         19D5uaBKL+V4WvrxHHGtNvQ0Ahd4Rn/VfeZcPzZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changcheng Liu <jerrliu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/247] net/mlx5: correct ECE offset in query qp output
Date:   Mon, 13 Jun 2022 12:09:58 +0200
Message-Id: <20220613094925.868599930@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changcheng Liu <jerrliu@nvidia.com>

[ Upstream commit 3fc2a9e89b3508a5cc0c324f26d7b4740ba8c456 ]

ECE field should be after opt_param_mask in query qp output.

Fixes: 6b646a7e4af6 ("net/mlx5: Add ability to read and write ECE options")
Signed-off-by: Changcheng Liu <jerrliu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fdf4589ab4d4..cd9d1c95129e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5028,12 +5028,11 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x20];
-	u8         ece[0x20];
+	u8         reserved_at_40[0x40];
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
-- 
2.35.1




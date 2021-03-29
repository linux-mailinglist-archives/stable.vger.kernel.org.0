Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09CA34C75B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhC2IOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhC2INl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D1F0619AD;
        Mon, 29 Mar 2021 08:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005616;
        bh=meNTi/rBbsxheEt7c3c8egZcU5lgauhmABnY9cYU9Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8Gy9C2a5BHWTn6fVXw6SrsAAf3hiHAD7O5FcQKM+jcSY4VBhcEhIrFU3qmcO2AI8
         5z/cLRywDHNQ891YuPT/P3edYIrf/17lAlWRlJzJhuK12CR1W6l1CEzA5YF+dt/N/L
         Kww8ZKuGEoeDnkpudWu/dHvcq14wQfxloJ/1Vwyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/111] net/mlx5e: Dont match on Geneve options in case option masks are all zero
Date:   Mon, 29 Mar 2021 09:58:04 +0200
Message-Id: <20210329075617.068170920@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 385d40b042e60aa0b677d7b400a0fefb44bcbaf4 ]

The cited change added offload support for Geneve options without verifying
the validity of the options masks, this caused offload of rules with match
on Geneve options with class,type and data masks which are zero to fail.

Fix by ignoring the match on Geneve options in case option masks are
all zero.

Fixes: 9272e3df3023 ("net/mlx5e: Geneve, Add support for encap/decap flows offload")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 951ea26d96bc..6d27f69cc7fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -227,6 +227,10 @@ static int mlx5e_tc_tun_parse_geneve_options(struct mlx5e_priv *priv,
 	option_key = (struct geneve_opt *)&enc_opts.key->data[0];
 	option_mask = (struct geneve_opt *)&enc_opts.mask->data[0];
 
+	if (option_mask->opt_class == 0 && option_mask->type == 0 &&
+	    !memchr_inv(option_mask->opt_data, 0, option_mask->length * 4))
+		return 0;
+
 	if (option_key->length > max_tlv_option_data_len) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Matching on GENEVE options: unsupported option len");
-- 
2.30.1




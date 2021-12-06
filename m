Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314C1469B33
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbhLFPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:13:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60340 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356274AbhLFPLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:11:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D0B6132C;
        Mon,  6 Dec 2021 15:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B846C341C5;
        Mon,  6 Dec 2021 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803283;
        bh=OBWBmo6K4fpCQLaAJRLSWZdOGA1SBUi1nsO8h15xK4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDP4yc0WWeWh+lZf0dkD42ukPI75CGjdJRoW6hIeSY7E16lScdH/U/SGyyFSOURAn
         g8AZyjgVrYEMUd2WqU3zBSsWeCxI8fNrUxb2zKdFvVHxic8UAEbrWzSl8W8MQkMJX0
         PMA7Y+Uif5MpxZ6aGbvbaSxPXAuBklaLV9hdEXF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 093/106] net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()
Date:   Mon,  6 Dec 2021 15:56:41 +0100
Message-Id: <20211206145558.747178592@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

commit addad7643142f500080417dd7272f49b7a185570 upstream.

In mlx4_en_try_alloc_resources(), mlx4_en_copy_priv() is called and
tmp->tx_cq will be freed on the error path of mlx4_en_copy_priv().
After that mlx4_en_alloc_resources() is called and there is a dereference
of &tmp->tx_cq[t][i] in mlx4_en_alloc_resources(), which could lead to
a use after free problem on failure of mlx4_en_copy_priv().

Fix this bug by adding a check of mlx4_en_copy_priv()

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_MLX4_EN=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: ec25bc04ed8e ("net/mlx4_en: Add resilience in low memory systems")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20211130164438.190591-1-zhou1615@umn.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2283,9 +2283,14 @@ int mlx4_en_try_alloc_resources(struct m
 				bool carry_xdp_prog)
 {
 	struct bpf_prog *xdp_prog;
-	int i, t;
+	int i, t, ret;
 
-	mlx4_en_copy_priv(tmp, priv, prof);
+	ret = mlx4_en_copy_priv(tmp, priv, prof);
+	if (ret) {
+		en_warn(priv, "%s: mlx4_en_copy_priv() failed, return\n",
+			__func__);
+		return ret;
+	}
 
 	if (mlx4_en_alloc_resources(tmp)) {
 		en_warn(priv,



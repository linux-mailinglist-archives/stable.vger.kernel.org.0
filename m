Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C1B278810
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgIYMwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgIYMwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B1A2075E;
        Fri, 25 Sep 2020 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038335;
        bh=pZyRP7uN2yaBC6uVXxQEhhvLSyA7oPj4hd9KWXNcxj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVSDDNeBJ/CHBrUVOE3nhqkhUfN8NwRvVSYeohB6fFixCF/ptFXLdagyCtpYwXbES
         /vAHOdrNVCsYQ1AJQTZpvDEK/VOD0mZgxliwW8sOB29WRZZfdzjIFk/v9Po+czu2Wd
         +S/wcwjuxkBkpcY9c3tYHc9xQqKaxJBQQwglHbB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.4 31/43] net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported
Date:   Fri, 25 Sep 2020 14:48:43 +0200
Message-Id: <20200925124728.285675686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 8f0bcd19b1da3f264223abea985b9462e85a3718 ]

The set of TLS TX global SW counters in mlx5e_tls_sw_stats_desc
is updated from all rings by using atomic ops.
This set of stats is used only in the FPGA TLS use case, not in
the Connect-X TLS one, where regular per-ring counters are used.

Do not expose them in the Connect-X use case, as this would cause
counter duplication. For example, tx_tls_drop_no_sync_data would
appear twice in the ethtool stats.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c |   12 +++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -35,7 +35,6 @@
 #include <net/sock.h>
 
 #include "en.h"
-#include "accel/tls.h"
 #include "fpga/sdk.h"
 #include "en_accel/tls.h"
 
@@ -51,9 +50,14 @@ static const struct counter_desc mlx5e_t
 
 #define NUM_TLS_SW_COUNTERS ARRAY_SIZE(mlx5e_tls_sw_stats_desc)
 
+static bool is_tls_atomic_stats(struct mlx5e_priv *priv)
+{
+	return priv->tls && !mlx5_accel_is_ktls_device(priv->mdev);
+}
+
 int mlx5e_tls_get_count(struct mlx5e_priv *priv)
 {
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	return NUM_TLS_SW_COUNTERS;
@@ -63,7 +67,7 @@ int mlx5e_tls_get_strings(struct mlx5e_p
 {
 	unsigned int i, idx = 0;
 
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)
@@ -77,7 +81,7 @@ int mlx5e_tls_get_stats(struct mlx5e_pri
 {
 	int i, idx = 0;
 
-	if (!priv->tls)
+	if (!is_tls_atomic_stats(priv))
 		return 0;
 
 	for (i = 0; i < NUM_TLS_SW_COUNTERS; i++)



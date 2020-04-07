Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290481A0B1D
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgDGKXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728566AbgDGKXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5FE620857;
        Tue,  7 Apr 2020 10:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255028;
        bh=SnyYKb+p9HafguymzY8zN2qEjwCS+JtjSBcFvZqGnq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzebdYBPAP8fVt1Ce5/T0r406XV6ASEwe+F8WLXhVF+MPoGnxloUKXtKqbZgVdfJ6
         d0F/DrbNlwpHaLg6jcQcSwuXuE2eTTGDlF7Kn0DBbzz/mRuPSDBxq9jRJMVgh9O86r
         sisZKjcnZQcnsIb3RtYt2jXTLXbHNvg6LQYjk6BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/36] net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow
Date:   Tue,  7 Apr 2020 12:21:44 +0200
Message-Id: <20200407101455.794161541@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 56917766def72f5afdf4235adb91b6897ff26d9d ]

We have an off-by-1 issue in the TCP seq comparison.
The last sequence number that belongs to the TCP packet's payload
is not "start_seq + len", but one byte before it.
Fix it so the 'ends_before' is evaluated properly.

This fixes a bug that results in error completions in the
kTLS HW offload flows.

Fixes: ffbd9ca94e2e ("net/mlx5e: kTLS, Fix corner-case checks in TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index f260dd96873bf..52a56622034a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -218,7 +218,7 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	 *    this packet was already acknowledged and its record info
 	 *    was released.
 	 */
-	ends_before = before(tcp_seq + datalen, tls_record_start_seq(record));
+	ends_before = before(tcp_seq + datalen - 1, tls_record_start_seq(record));
 
 	if (unlikely(tls_record_is_start_marker(record))) {
 		ret = ends_before ? MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
-- 
2.20.1




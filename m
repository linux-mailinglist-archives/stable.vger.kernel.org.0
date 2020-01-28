Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD42514BBBA
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgA1OCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727609AbgA1OCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E02B24685;
        Tue, 28 Jan 2020 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220136;
        bh=TM1lYX9ZBR0sv2CsQm5I0T9nmMCc2TsB4mRuu+HeEvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY5A0bx+Tqm4I0LxMW+jiFB/sTOe5pU6rA0gYq4Lzryl7nBxEiUi+kmr7zYGfXaQf
         JR3tHnyDUg9zaANetBqOVkRwKe+rcOkWw414t4vDU5QQvn8bbQQzTAy3Ufv4ltM9ti
         MEc0t6x5Q2c2Vv7mOs7qxaZ25DuLQYP3Brk+fJ7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 031/104] net/mlx5e: kTLS, Do not send decrypted-marked SKBs via non-accel path
Date:   Tue, 28 Jan 2020 14:59:52 +0100
Message-Id: <20200128135821.569664814@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

commit 342508c1c7540e281fd36151c175ba5ff954a99f upstream.

When TCP out-of-order is identified (unexpected tcp seq mismatch), driver
analyzes the packet and decides what handling should it get:
1. go to accelerated path (to be encrypted in HW),
2. go to regular xmit path (send w/o encryption),
3. drop.

Packets marked with skb->decrypted by the TLS stack in the TX flow skips
SW encryption, and rely on the HW offload.
Verify that such packets are never sent un-encrypted on the wire.
Add a WARN to catch such bugs, and prefer dropping the packet in these cases.

Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   14 +++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -458,12 +458,18 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb
 		enum mlx5e_ktls_sync_retval ret =
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
 
-		if (likely(ret == MLX5E_KTLS_SYNC_DONE))
+		switch (ret) {
+		case MLX5E_KTLS_SYNC_DONE:
 			*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
-		else if (ret == MLX5E_KTLS_SYNC_FAIL)
+			break;
+		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
+			if (likely(!skb->decrypted))
+				goto out;
+			WARN_ON_ONCE(1);
+			/* fall-through */
+		default: /* MLX5E_KTLS_SYNC_FAIL */
 			goto err_out;
-		else /* ret == MLX5E_KTLS_SYNC_SKIP_NO_DATA */
-			goto out;
+		}
 	}
 
 	priv_tx->expected_seq = seq + datalen;



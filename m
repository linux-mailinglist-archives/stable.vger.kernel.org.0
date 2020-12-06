Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B02D0418
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgLFLnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbgLFLnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 05/39] net/tls: Protect from calling tls_dev_del for TLS RX twice
Date:   Sun,  6 Dec 2020 12:17:09 +0100
Message-Id: <20201206111554.929819439@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 025cc2fb6a4e84e9a0552c0017dcd1c24b7ac7da ]

tls_device_offload_cleanup_rx doesn't clear tls_ctx->netdev after
calling tls_dev_del if TLX TX offload is also enabled. Clearing
tls_ctx->netdev gets postponed until tls_device_gc_task. It leaves a
time frame when tls_device_down may get called and call tls_dev_del for
RX one extra time, confusing the driver, which may lead to a crash.

This patch corrects this racy behavior by adding a flag to prevent
tls_device_down from calling tls_dev_del the second time.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20201125221810.69870-1-saeedm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h    |    6 ++++++
 net/tls/tls_device.c |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -221,6 +221,12 @@ enum tls_context_flags {
 	 * to be atomic.
 	 */
 	TLS_TX_SYNC_SCHED = 1,
+	/* tls_dev_del was called for the RX side, device state was released,
+	 * but tls_ctx->netdev might still be kept, because TX-side driver
+	 * resources might not be released yet. Used to prevent the second
+	 * tls_dev_del call in tls_device_down if it happens simultaneously.
+	 */
+	TLS_RX_DEV_CLOSED = 2,
 };
 
 struct cipher_context {
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1163,6 +1163,8 @@ void tls_device_offload_cleanup_rx(struc
 	if (tls_ctx->tx_conf != TLS_HW) {
 		dev_put(netdev);
 		tls_ctx->netdev = NULL;
+	} else {
+		set_bit(TLS_RX_DEV_CLOSED, &tls_ctx->flags);
 	}
 out:
 	up_read(&device_offload_lock);
@@ -1192,7 +1194,8 @@ static int tls_device_down(struct net_de
 		if (ctx->tx_conf == TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_TX);
-		if (ctx->rx_conf == TLS_HW)
+		if (ctx->rx_conf == TLS_HW &&
+		    !test_bit(TLS_RX_DEV_CLOSED, &ctx->flags))
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
 		WRITE_ONCE(ctx->netdev, NULL);



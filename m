Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E61CAF7A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgEHMjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728512AbgEHMjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:39:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5812496A;
        Fri,  8 May 2020 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941546;
        bh=ms3FREfyZi9NtI4y72lyzMZ3+AJnRMj4Cp5dTvwD+FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evkH0eOHrYJbID5CWpyNbgDzwn3WGn6hfieZnYbADtB8XkyAjTkYKwCahxceynCWj
         HBCh16DzzgHtkXeniFacQ0nmMpeHmFU9/tdCkkBjnbyZ00OKQG9KcXN1zVjhA1v21P
         wjLU5+TZE3SISS/rYVsu+ADYAwVWaHvfoTNk2A44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rana Shahout <ranas@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 076/312] net/mlx5e: Fix MLX5E_100BASE_T define
Date:   Fri,  8 May 2020 14:31:07 +0200
Message-Id: <20200508123129.872051428@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rana Shahout <ranas@mellanox.com>

commit 6e4c21894673baabdbef03c3ac2458a28246128b upstream.

Bit 25 of eth_proto_capability in PTYS register is
1000Base-TT and not 100Base-T.

Fixes: f62b8bb8f2d3 ('net/mlx5: Extend mlx5_core to
support ConnectX-4 Ethernet functionality')
Signed-off-by: Rana Shahout <ranas@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -543,7 +543,7 @@ enum mlx5e_link_mode {
 	MLX5E_100GBASE_KR4	 = 22,
 	MLX5E_100GBASE_LR4	 = 23,
 	MLX5E_100BASE_TX	 = 24,
-	MLX5E_100BASE_T		 = 25,
+	MLX5E_1000BASE_T	 = 25,
 	MLX5E_10GBASE_T		 = 26,
 	MLX5E_25GBASE_CR	 = 27,
 	MLX5E_25GBASE_KR	 = 28,
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -138,10 +138,10 @@ static const struct {
 	[MLX5E_100BASE_TX]   = {
 		.speed      = 100,
 	},
-	[MLX5E_100BASE_T]    = {
-		.supported  = SUPPORTED_100baseT_Full,
-		.advertised = ADVERTISED_100baseT_Full,
-		.speed      = 100,
+	[MLX5E_1000BASE_T]    = {
+		.supported  = SUPPORTED_1000baseT_Full,
+		.advertised = ADVERTISED_1000baseT_Full,
+		.speed      = 1000,
 	},
 	[MLX5E_10GBASE_T]    = {
 		.supported  = SUPPORTED_10000baseT_Full,



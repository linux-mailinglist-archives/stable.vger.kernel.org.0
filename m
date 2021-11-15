Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756B14513F8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348805AbhKOUAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344168AbhKOTX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8526863317;
        Mon, 15 Nov 2021 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002391;
        bh=M5wreoI7ZtZqdicl6O9B4Piidboyiz02lSZiB1jm0qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVi74BjPkfk82WRZmhIV64FEF0st20PYfCiRp1cciw2ApzPezYMZnMysPjNn72YnF
         d4gW48ROhY0WuOtQh9P2u+R4x+NaGlQrziUUz+6yX0EUwb22eF4EXi1FxfAqcyx3d+
         yIVLpd+7FnPDLCO/wSBrYaB1aAhkWemxrtfb2YBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 548/917] nfp: fix NULL pointer access when scheduling dim work
Date:   Mon, 15 Nov 2021 18:00:43 +0100
Message-Id: <20211115165447.355627268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit f8d384a640dd32aaf0a05fec137ccbf0e986b09f ]

Each rx/tx ring has a related dim work, when rx/tx ring number is
decreased by `ethtool -L`, the corresponding rx_ring or tx_ring is
assigned NULL, while its related work is not destroyed. When scheduled,
the work will access NULL pointer.

Fixes: 9d32e4e7e9e1 ("nfp: add support for coalesce adaptive feature")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5bfa22accf2c9..f8b880c8e5148 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2067,7 +2067,7 @@ static int nfp_net_poll(struct napi_struct *napi, int budget)
 		if (napi_complete_done(napi, pkts_polled))
 			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
 
-	if (r_vec->nfp_net->rx_coalesce_adapt_on) {
+	if (r_vec->nfp_net->rx_coalesce_adapt_on && r_vec->rx_ring) {
 		struct dim_sample dim_sample = {};
 		unsigned int start;
 		u64 pkts, bytes;
@@ -2082,7 +2082,7 @@ static int nfp_net_poll(struct napi_struct *napi, int budget)
 		net_dim(&r_vec->rx_dim, dim_sample);
 	}
 
-	if (r_vec->nfp_net->tx_coalesce_adapt_on) {
+	if (r_vec->nfp_net->tx_coalesce_adapt_on && r_vec->tx_ring) {
 		struct dim_sample dim_sample = {};
 		unsigned int start;
 		u64 pkts, bytes;
-- 
2.33.0




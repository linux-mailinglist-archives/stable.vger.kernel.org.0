Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9622C0AC4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgKWM1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730321AbgKWM1f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EBC208DB;
        Mon, 23 Nov 2020 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134454;
        bh=ssjlf4N4LIzYEDw3kIu3/dakhYIbaVaAErTXHhZXfJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbHOsb5XJBVgEtdvVdI5XSXgzQuXO9ALEeNbMrl0FwJ63PX5UDJADsb87ZxFPBoeS
         zZ0Itvs4RKyGgkqwv4E9Sst6Q7fOw/e3v5Yq2FDj5mXc+Ywng0ib5TWshlPc2FPIQ5
         FJ83e2pG5BOMuwunEeF1/aCfvmpnQh6h8vnd8szo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 08/60] net: bridge: add missing counters to ndo_get_stats64 callback
Date:   Mon, 23 Nov 2020 13:21:50 +0100
Message-Id: <20201123121805.439202437@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 7a30ecc9237681bb125cbd30eee92bef7e86293d ]

In br_forward.c and br_input.c fields dev->stats.tx_dropped and
dev->stats.multicast are populated, but they are ignored in
ndo_get_stats64.

Fixes: 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/58ea9963-77ad-a7cf-8dfd-fc95ab95f606@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -186,6 +186,7 @@ static void br_get_stats64(struct net_de
 		sum.rx_packets += tmp.rx_packets;
 	}
 
+	netdev_stats_to_stats64(stats, &dev->stats);
 	stats->tx_bytes   = sum.tx_bytes;
 	stats->tx_packets = sum.tx_packets;
 	stats->rx_bytes   = sum.rx_bytes;



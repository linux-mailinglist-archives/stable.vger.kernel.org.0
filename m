Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51312C057C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgKWMWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgKWMWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:22:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 536D320728;
        Mon, 23 Nov 2020 12:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134172;
        bh=1XQtK25VGHgRdqoJbM3T5/nHKTbMxev+gICu3bVRwTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cISI/1s+bakS+PPCjb0ani6p1TZj/yE55D4eVmhpmS4jj7RMDSQzYOtg/WgCOmsLt
         sDqfGZFrNH8lu/4wwq2DVrhWD0GDRI8V4vWt/Waner9GzuvBztRwSbTVlcfaxnWktm
         ShIBvK+6a0qLely6ydHcVEAj4Md6IAyMYiIGJdzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 04/38] net: bridge: add missing counters to ndo_get_stats64 callback
Date:   Mon, 23 Nov 2020 13:21:50 +0100
Message-Id: <20201123121804.529864052@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
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
@@ -166,6 +166,7 @@ static struct rtnl_link_stats64 *br_get_
 		sum.rx_packets += tmp.rx_packets;
 	}
 
+	netdev_stats_to_stats64(stats, &dev->stats);
 	stats->tx_bytes   = sum.tx_bytes;
 	stats->tx_packets = sum.tx_packets;
 	stats->rx_bytes   = sum.rx_bytes;



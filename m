Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F03812CA3B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfL2RWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfL2RWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:22:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06BB207FD;
        Sun, 29 Dec 2019 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640163;
        bh=Panl6ey8aJhDX79dopph3tzoDf23sIp1mSKPr/j7FDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1wG8cp47ZlzNEomJJI9aiGGXqNMChKBTTw/wEHedod1u2KoaUpspDku1v9ftxhTp
         mv6ve4huaU04tiA1NGyyVFbXtxckD7BZtbXCe9k7e2E71egXGgo03y5DDwRoPO96zz
         fHzxmz3+UNvQCEB5HhC/cXCHuIFEvFSAWZPCtPHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 009/161] qede: Fix multicast mac configuration
Date:   Sun, 29 Dec 2019 18:17:37 +0100
Message-Id: <20191229162358.554444582@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>

[ Upstream commit 0af67e49b018e7280a4227bfe7b6005bc9d3e442 ]

Driver doesn't accommodate the configuration for max number
of multicast mac addresses, in such particular case it leaves
the device with improper/invalid multicast configuration state,
causing connectivity issues (in lacp bonding like scenarios).

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1181,7 +1181,7 @@ qede_configure_mcast_filtering(struct ne
 	netif_addr_lock_bh(ndev);
 
 	mc_count = netdev_mc_count(ndev);
-	if (mc_count < 64) {
+	if (mc_count <= 64) {
 		netdev_for_each_mc_addr(ha, ndev) {
 			ether_addr_copy(temp, ha->addr);
 			temp += ETH_ALEN;



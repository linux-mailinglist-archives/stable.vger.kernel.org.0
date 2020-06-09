Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267A51F4643
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgFISZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgFIRqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65CCF2081A;
        Tue,  9 Jun 2020 17:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724793;
        bh=0l8c9k+8yFocyzIgv8IfzIQTVYUyVs5GizGv3/sGW/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iAo/PJIndw9TdZx/YluEk0PezjzWAScc175htn+7lKoqB3XTN9I7gCJflJux/yRDb
         g/V4Q5qAfZ1oM2fFkskhk35Vq0ZGsbyhAGyXWLADec32k7iarJNlzzR5H5hsis5+U3
         uqhTgp2FeaeGtWrf/+QzNKd5A/nfIZkfKe5gQ5Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>,
        Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/36] net: bmac: Fix read of MAC address from ROM
Date:   Tue,  9 Jun 2020 19:44:11 +0200
Message-Id: <20200609173933.927328978@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609173933.288044334@linuxfoundation.org>
References: <20200609173933.288044334@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>

[ Upstream commit ef01cee2ee1b369c57a936166483d40942bcc3e3 ]

In bmac_get_station_address, We're reading two bytes at a time from ROM,
but we do that six times, resulting in 12 bytes of read & writes. This
means we will write off the end of the six-byte destination buffer.

This change fixes the for-loop to only read/write six bytes.

Based on a proposed fix from Finn Thain <fthain@telegraphics.com.au>.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Reported-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Reported-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/bmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index a65d7a60f116..ffa7e7e6d18d 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1187,7 +1187,7 @@ bmac_get_station_address(struct net_device *dev, unsigned char *ea)
 	int i;
 	unsigned short data;
 
-	for (i = 0; i < 6; i++)
+	for (i = 0; i < 3; i++)
 		{
 			reset_and_select_srom(dev);
 			data = read_srom(dev, i + EnetAddressOffset/2, SROMAddressBits);
-- 
2.25.1




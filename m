Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F293B2F1509
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbhAKNek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731731AbhAKNOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83C702250F;
        Mon, 11 Jan 2021 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370844;
        bh=jjYAseWg2HOjRMlOeY2x4tbpR7/ZWjLk5Wb9MXxpk9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT8wTelsrIIY0gozHDLkJyrEaMqNiY3Rm+xTAE3NDwwc20Uu5SdHPCQeYTjH2y3Ca
         11MsG9i9TxMfdQmalL2QyRrCZCal23p3epKv//cwL0JvGdhAt1mAWain5P1znyTJme
         EUHCqWYTe2fp+1Ing8STU9ETUibWZEmM+64MzmD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liron Himi <lironh@marvell.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 005/145] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
Date:   Mon, 11 Jan 2021 14:00:29 +0100
Message-Id: <20210111130048.769976171@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit fec6079b2eeab319d9e3d074f54d3b6f623e9701 ]

Current PPPoE+IPv6 entry is jumping to 'next-hdr'
field and not to 'DIP' field as done for IPv4.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Reported-by: Liron Himi <lironh@marvell.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1608230266-22111-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -1680,8 +1680,9 @@ static int mvpp2_prs_pppoe_init(struct m
 	mvpp2_prs_sram_next_lu_set(&pe, MVPP2_PRS_LU_IP6);
 	mvpp2_prs_sram_ri_update(&pe, MVPP2_PRS_RI_L3_IP6,
 				 MVPP2_PRS_RI_L3_PROTO_MASK);
-	/* Skip eth_type + 4 bytes of IPv6 header */
-	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 4,
+	/* Jump to DIP of IPV6 header */
+	mvpp2_prs_sram_shift_set(&pe, MVPP2_ETH_TYPE_LEN + 8 +
+				 MVPP2_MAX_L3_ADDR_SIZE,
 				 MVPP2_PRS_SRAM_OP_SEL_SHIFT_ADD);
 	/* Set L3 offset */
 	mvpp2_prs_sram_offset_set(&pe, MVPP2_PRS_SRAM_UDF_TYPE_L3,



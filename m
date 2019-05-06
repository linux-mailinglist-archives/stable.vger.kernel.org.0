Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4878B14F26
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfEFOfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfEFOfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EAC020C01;
        Mon,  6 May 2019 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153344;
        bh=fswLb29KFSWxhWuB7kR8SScaaOcEFb4ErFrPM2jSrw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2CdfFK5UDttxSrm7ro3JGe+RdTZ7FsyS7RXPs1RHreu+G4PJVFOMjBZJuhKrNRoH
         IMKTJShqK7vRO+gjkIca0FW1oTyTMzyqV4Y+tk5+dJeP2Sem5TtgwTXr7F4dGqEL/6
         vpvJ/JYkvintNPpk9TZWvZledO7uZY6RGHenVceU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 054/122] net: stmmac: fix dropping of multi-descriptor RX frames
Date:   Mon,  6 May 2019 16:31:52 +0200
Message-Id: <20190506143059.782324555@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8ac0c24fe1c256af6644caf3d311029440ec2fbd ]

Packets without the last descriptor set should be dropped early. If we
receive a frame larger than the DMA buffer, the HW will continue using the
next descriptor. Driver mistakes these as individual frames, and sometimes
a truncated frame (without the LD set) may look like a valid packet.

This fixes a strange issue where the system replies to 4098-byte ping
although the MTU/DMA buffer size is set to 4096, and yet at the same
time it's logging an oversized packet.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index c42ef6c729c0..5202d6ad7919 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -201,6 +201,11 @@ static int enh_desc_get_rx_status(void *data, struct stmmac_extra_stats *x,
 	if (unlikely(rdes0 & RDES0_OWN))
 		return dma_own;
 
+	if (unlikely(!(rdes0 & RDES0_LAST_DESCRIPTOR))) {
+		stats->rx_length_errors++;
+		return discard_frame;
+	}
+
 	if (unlikely(rdes0 & RDES0_ERROR_SUMMARY)) {
 		if (unlikely(rdes0 & RDES0_DESCRIPTOR_ERROR)) {
 			x->rx_desc++;
-- 
2.20.1




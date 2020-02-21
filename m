Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8C1670D8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgBUHsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:48:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727797AbgBUHsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:48:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E9B24656;
        Fri, 21 Feb 2020 07:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271325;
        bh=/73/ybL08y3MfdJofkFDbGAMVH9v2eU7vMke69tEJVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwIp8nspx37DndZU5HTBtQ61cvbI2zwY72rFcy62PqqIxQRuq6n3APXOsLhkmbtfk
         RPwIzkbAb69m0AtfCcw/rO/fASbSPvP94ESULVno5JbFmhMk4aOq86vW3gpxWMTXGQ
         zlpiejLV/UgEN+LyJCqBUxRjaaZEToZTbaJJSz8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Wandun <chenwandun@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 124/399] enetc: remove variable tc_max_sized_frame set but not used
Date:   Fri, 21 Feb 2020 08:37:29 +0100
Message-Id: <20200221072414.528370116@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit 6525b5ef65fdaf8a782449fb5d585195b573c2c1 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/freescale/enetc/enetc_qos.c: In function enetc_setup_tc_cbs:
drivers/net/ethernet/freescale/enetc/enetc_qos.c:195:6: warning: variable tc_max_sized_frame set but not used [-Wunused-but-set-variable]

Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 2e99438cb1bf3..9190ffc9f6b21 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -192,7 +192,6 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	u32 hi_credit_bit, hi_credit_reg;
 	u32 max_interference_size;
 	u32 port_frame_max_size;
-	u32 tc_max_sized_frame;
 	u8 tc = cbs->queue;
 	u8 prio_top, prio_next;
 	int bw_sum = 0;
@@ -250,7 +249,7 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 		return -EINVAL;
 	}
 
-	tc_max_sized_frame = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+	enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
 
 	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
 	 *
-- 
2.20.1




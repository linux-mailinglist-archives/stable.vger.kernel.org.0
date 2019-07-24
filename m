Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15FE473DD0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389079AbfGXUUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391213AbfGXTrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73946205C9;
        Wed, 24 Jul 2019 19:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997636;
        bh=Ac4+0kdxBm/sPaXK+zxCsEvKI3E60ZZYmePwII+BD2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYx5GO4sbx4oiKUfNFsW7I1y63r+LgrBGSvk0jYMDPIg49LtBKqOsZseUUr03Ol17
         xqSt4AxyjIM3JUPK2nsyO9H1PFAWvKwQG9appfqXXCvv6lFyMMCEx2snEItElrQWGe
         9D3xGhDSGC7TTxg+4VrCkAca7eybMm52+htUzosw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 093/371] qed: iWARP - Fix tc for MPA ll2 connection
Date:   Wed, 24 Jul 2019 21:17:25 +0200
Message-Id: <20190724191731.827411154@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cb94d52b93c74fe1f2595734fabeda9f8ae891ee ]

The driver needs to assign a lossless traffic class for the MPA ll2
connection to ensure no packets are dropped when returning from the
driver as they will never be re-transmitted by the peer.

Fixes: ae3488ff37dc ("qed: Add ll2 connection for processing unaligned MPA packets")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index ded556b7bab5..eeea8683d99b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2708,6 +2708,8 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	data.input.rx_num_desc = n_ooo_bufs * 2;
 	data.input.tx_num_desc = data.input.rx_num_desc;
 	data.input.tx_max_bds_per_packet = QED_IWARP_MAX_BDS_PER_FPDU;
+	data.input.tx_tc = PKT_LB_TC;
+	data.input.tx_dest = QED_LL2_TX_DEST_LB;
 	data.p_connection_handle = &iwarp_info->ll2_mpa_handle;
 	data.input.secondary_queue = true;
 	data.cbs = &cbs;
-- 
2.20.1




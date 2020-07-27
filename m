Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A86222EEE7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgG0OLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgG0OLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3AFE2083E;
        Mon, 27 Jul 2020 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859099;
        bh=QeYImvGnpz91Ee2T2NshMXtxBus8Lw1i2ipm1jF76UA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2+HnHS+Vst38t+bCX9UHDMfWHAj+G0skcboekOTVXU191NXeynOZ9y2lAwfheD+E
         DRAEL6BvJaEOytAlsUNldyuqOg1xjKAAmUDjHx8bh7mrPYE8aW68T3AAWGLHXvHqSP
         jrj3ym+ulA5qmGxQRj3HU6hi/NnMmAkpz2FUtNIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/86] qed: suppress "dont support RoCE & iWARP" flooding on HW init
Date:   Mon, 27 Jul 2020 16:04:09 +0200
Message-Id: <20200727134916.195608026@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit 1ea999039fe7c7953da2fbb7ca7c3ef00064d328 ]

Change the verbosity of the "don't support RoCE & iWARP simultaneously"
warning to debug level to stop flooding on driver/hardware initialization:

[    4.783230] qede 01:00.00: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth0]
[    4.810020] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    4.861186] qede 01:00.01: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth1]
[    4.893311] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.181713] qede a1:00.00: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth2]
[    5.224740] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.276449] qede a1:00.01: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth3]
[    5.318671] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only
[    5.369548] qede a1:00.02: Storm FW 8.37.7.0, Management FW 8.52.9.0
[MBI 15.10.6] [eth4]
[    5.411645] [qed_rdma_set_pf_params:2076()]Current day drivers don't
support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only

Fixes: e0a8f9de16fc ("qed: Add iWARP enablement support")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index f3d7c38f539a8..734462f8d881c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2074,8 +2074,8 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
 	num_srqs = min_t(u32, QED_RDMA_MAX_SRQS, p_params->num_srqs);
 
 	if (p_hwfn->mcp_info->func_info.protocol == QED_PCI_ETH_RDMA) {
-		DP_NOTICE(p_hwfn,
-			  "Current day drivers don't support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only\n");
+		DP_VERBOSE(p_hwfn, QED_MSG_SP,
+			   "Current day drivers don't support RoCE & iWARP simultaneously on the same PF. Default to RoCE-only\n");
 		p_hwfn->hw_info.personality = QED_PCI_ETH_ROCE;
 	}
 
-- 
2.25.1




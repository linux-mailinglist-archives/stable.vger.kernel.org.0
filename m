Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8751722EF48
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgG0OPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730657AbgG0OPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDECB2073E;
        Mon, 27 Jul 2020 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859307;
        bh=uyV1EY6BqY+Ry98Gg2lQg0RI0L86Z4p/Qz5iphu125s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GS9O6mEeZeJAd4XMPE8CKITAODDRQO9qKu+bW4+e3isg9WrAdDKtcq6lkqtaLk7FA
         B3UjjvfvXWzllaXHMGJywC+Aro9Kt75vEFpztwz4noKfjlwt5eet3fWWPBGOJObgJV
         pAuyT0RPaDAt4HNEovPI8viznmS8nG270kgXCWtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/138] qed: suppress "dont support RoCE & iWARP" flooding on HW init
Date:   Mon, 27 Jul 2020 16:04:12 +0200
Message-Id: <20200727134928.260333603@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
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
index 1d6dfba0c034d..8ea46b81b7395 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -2073,8 +2073,8 @@ static void qed_rdma_set_pf_params(struct qed_hwfn *p_hwfn,
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




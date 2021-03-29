Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC4034C8C0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhC2IYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbhC2IX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A0E2619BB;
        Mon, 29 Mar 2021 08:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006197;
        bh=mqr5PF43DWPLKILTuuTBEO1NrWrz3vQ6zdgv4HfU4Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzQwuEwaFGoKYNaPRo03Xw7TvlZR1/XRgUKRcyMFAecPFIclgRfakYvcSFWzNtlUf
         h0AsJbZ4rM4LV5LFNaie21cfyJDMnq5KRyD8YHtkI5f8xJbeyfugF/UabQBZfmDrCM
         dxqNxaYEuPz4NwAkTF2ctykCecy8TmbcglcKGkoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/221] octeontx2-pf: Clear RSS enable flag on interace down
Date:   Mon, 29 Mar 2021 09:58:05 +0200
Message-Id: <20210329075634.300950792@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit f12098ce9b43e1a6fcaa524acbd90f9118a74c0a ]

RSS configuration can not be get/set when interface is in down state
as they required mbox communication. RSS enable flag status
is used for set/get configuration. Current code do not clear the
RSS enable flag on interface down which lead to mbox error while
trying to set/get RSS configuration.

Fixes: 85069e95e531 ("octeontx2-pf: Receive side scaling support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 66f1a212f1f4..9fef9be015e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1616,6 +1616,7 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
+	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
 	netif_carrier_off(netdev);
@@ -1628,6 +1629,10 @@ int otx2_stop(struct net_device *netdev)
 	/* First stop packet Rx/Tx */
 	otx2_rxtx_enable(pf, false);
 
+	/* Clear RSS enable flag */
+	rss = &pf->hw.rss_info;
+	rss->enable = false;
+
 	/* Cleanup Queue IRQ */
 	vec = pci_irq_vector(pf->pdev,
 			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
-- 
2.30.1




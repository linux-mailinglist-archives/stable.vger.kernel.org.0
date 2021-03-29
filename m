Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F1E34CA7C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhC2Iio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhC2IhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A3B619B7;
        Mon, 29 Mar 2021 08:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006981;
        bh=tu2wDbXbZgYo5OU+2U5aXiJgpGuERpERTU5bssKNt8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f98ZRPsTxT0XcST+plp/2yVFJQsNPf/E5pJLyppef/ddyuSFmr9lJosZ1I+DYpZHm
         r5dENHj7/KP5AkRsxql5Fwog7DopkggpuzsCcTweWsAdNN2YE2JFLiCYiQb/4V/Pgz
         W4u4mGuygzSytUIgz1dJQNUVw4NZWVfo7FC6kVQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 176/254] octeontx2-pf: Clear RSS enable flag on interace down
Date:   Mon, 29 Mar 2021 09:58:12 +0200
Message-Id: <20210329075638.940041930@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
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
index 634d60655a74..07e841df5678 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1625,6 +1625,7 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
+	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
 	netif_carrier_off(netdev);
@@ -1637,6 +1638,10 @@ int otx2_stop(struct net_device *netdev)
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




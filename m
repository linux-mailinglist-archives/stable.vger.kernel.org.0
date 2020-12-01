Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E762C9B35
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgLAJFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389054AbgLAJFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:05:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0747E20770;
        Tue,  1 Dec 2020 09:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813485;
        bh=YA5Hb5iW4oPD5YG/PKpDlP0HxEPYoCp4gDPPfvoEFMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O768hO3+ZUDuxxd4PrNl/ow2jAPwibrjeiJkBjZpaKaFAukwnpDL/VdRvXG8p+cv1
         F2wTVcTpHdRnrhwLGAymbyuRFLofddQxiV3/229GMyq0/f9ADzSl3yWA+9sUIoA3Gr
         TGZ76ZiufC4vfbCcmAmvUfgn8PZk0MwUedAWIfAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/98] cxgb4: fix the panic caused by non smac rewrite
Date:   Tue,  1 Dec 2020 09:53:31 +0100
Message-Id: <20201201084657.749144116@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <rajur@chelsio.com>

[ Upstream commit bff453921ae105a8dbbad0ed7dd5f5ce424536e7 ]

SMT entry is allocated only when loopback Source MAC
rewriting is requested. Accessing SMT entry for non
smac rewrite cases results in kernel panic.

Fix the panic caused by non smac rewrite

Fixes: 937d84205884 ("cxgb4: set up filter action after rewrites")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
Link: https://lore.kernel.org/r/20201118143213.13319-1-rajur@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 202af8dc79662..cb50b41cd3df2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -630,7 +630,8 @@ int set_filter_wr(struct adapter *adapter, int fidx)
 		 FW_FILTER_WR_OVLAN_VLD_V(f->fs.val.ovlan_vld) |
 		 FW_FILTER_WR_IVLAN_VLDM_V(f->fs.mask.ivlan_vld) |
 		 FW_FILTER_WR_OVLAN_VLDM_V(f->fs.mask.ovlan_vld));
-	fwr->smac_sel = f->smt->idx;
+	if (f->fs.newsmac)
+		fwr->smac_sel = f->smt->idx;
 	fwr->rx_chan_rx_rpl_iq =
 		htons(FW_FILTER_WR_RX_CHAN_V(0) |
 		      FW_FILTER_WR_RX_RPL_IQ_V(adapter->sge.fw_evtq.abs_id));
-- 
2.27.0




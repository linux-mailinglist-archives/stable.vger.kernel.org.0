Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3DC3FDB43
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344699AbhIAMkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344332AbhIAMiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC93960F56;
        Wed,  1 Sep 2021 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499669;
        bh=9GNDmyD2bjPmvYYcPH5lzusCEqIUgNkJPiYS1mNI9ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0XThrxExr2Ddqq3LeKvv+xTxXWt4gCysUVrXMPt/L7HLYPwuVSs6Jex8s9qmk67j
         AgHxDXxl0yeuGp8EpF6OH+crX8evutFdZqyc8qATMdZSWan0/RDI+BNkqcHoNoCsBE
         MMdjIEvp2Qsi1VR/i0tFR58wSOLAUiGb39sPQsa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/103] cxgb4: dont touch blocked freelist bitmap after free
Date:   Wed,  1 Sep 2021 14:27:50 +0200
Message-Id: <20210901122301.914338365@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 43fed4d48d325e0a61dc2638a84da972fbb1087b ]

When adapter init fails, the blocked freelist bitmap is already freed
up and should not be touched. So, move the bitmap zeroing closer to
where it was successfully allocated. Also handle adapter init failure
unwind path immediately and avoid setting up RDMA memory windows.

Fixes: 5b377d114f2b ("cxgb4: Add debugfs facility to inject FL starvation")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 6698afad4379..3c28a1c3c1ed 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5072,6 +5072,7 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		ret = -ENOMEM;
 		goto bye;
 	}
+	bitmap_zero(adap->sge.blocked_fl, adap->sge.egr_sz);
 #endif
 
 	params[0] = FW_PARAM_PFVF(CLIP_START);
@@ -6792,13 +6793,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	setup_memwin(adapter);
 	err = adap_init0(adapter, 0);
-#ifdef CONFIG_DEBUG_FS
-	bitmap_zero(adapter->sge.blocked_fl, adapter->sge.egr_sz);
-#endif
-	setup_memwin_rdma(adapter);
 	if (err)
 		goto out_unmap_bar;
 
+	setup_memwin_rdma(adapter);
+
 	/* configure SGE_STAT_CFG_A to read WC stats */
 	if (!is_t4(adapter->params.chip))
 		t4_write_reg(adapter, SGE_STAT_CFG_A, STATSOURCE_T5_V(7) |
-- 
2.30.2




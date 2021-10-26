Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2A43AC9F
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 09:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhJZHJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 03:09:13 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:48634 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230467AbhJZHJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 03:09:12 -0400
X-UUID: 60955ca12e494260b8cd3ecb77638c75-20211026
X-UUID: 60955ca12e494260b8cd3ecb77638c75-20211026
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1803144527; Tue, 26 Oct 2021 15:06:47 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 26 Oct 2021 15:06:46 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Oct
 2021 15:06:45 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Oct 2021 15:06:45 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Chaotian Jing <chaotian.jing@mediatek.com>
CC:     Wenbin Mei <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] mmc: cqhci: clear HALT state after CQE enable
Date:   Tue, 26 Oct 2021 15:06:44 +0800
Message-ID: <20211026070644.9303-1-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While mmc0 enter suspend state, we need halt CQE to send legacy cmd(flush
cache) and disable cqe, for resume back, we enable CQE and not clear HALT
state.
In this case MediaTek mmc host controller will keep the value for HALT
state after CQE disable/enable flow, so the next CQE transfer after resume
will be timeout due to CQE is in HALT state, the log as below:
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: timeout for tag 2
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: ============ CQHCI REGISTER DUMP ===========
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Caps:      0x100020b6 | Version:  0x00000510
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Config:    0x00001103 | Control:  0x00000001
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int stat:  0x00000000 | Int enab: 0x00000006
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Int sig:   0x00000006 | Int Coal: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: TDL base:  0xfd05f000 | TDL up32: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Doorbell:  0x8000203c | TCN:      0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Dev queue: 0x00000000 | Dev Pend: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Task clr:  0x00000000 | SSC1:     0x00001000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: SSC2:      0x00000001 | DCMD rsp: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: RED mask:  0xfdf9a080 | TERRI:    0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: Resp idx:  0x00000000 | Resp arg: 0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQP:     0x00000000 | CRNQDUN:  0x00000000
<4>.(4)[318:kworker/4:1H]mmc0: cqhci: CRNQIS:    0x00000000 | CRNQIE:   0x00000000

This change check HALT state after CQE enable, if CQE is in HALT state, we
will clear it.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Cc: stable@vger.kernel.org
---
 drivers/mmc/host/cqhci-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
index ca8329d55f43..b0d30c35c390 100644
--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -282,6 +282,9 @@ static void __cqhci_enable(struct cqhci_host *cq_host)
 
 	cqhci_writel(cq_host, cqcfg, CQHCI_CFG);
 
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
+		cqhci_writel(cq_host, 0, CQHCI_CTL);
+
 	mmc->cqe_on = true;
 
 	if (cq_host->ops->enable)
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AD549A073
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384014AbiAXXHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843316AbiAXXDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:03:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51E6C06C59D;
        Mon, 24 Jan 2022 13:14:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C7861484;
        Mon, 24 Jan 2022 21:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420A9C340E5;
        Mon, 24 Jan 2022 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058871;
        bh=3Dr0Y8JmlRteCgNv3ytXBhi/7TFoA+6ATQj4UbNYrkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6yNJxHah0eXO/Hw0w8R34Gf8JgZcYi+i29fNfZaXF6dULUkRYQLiFutOtGrj9V9s
         e4CbmkvD1GGYIjr/p4gEqtSO3BMc5p+QwYctKuMzv1QQN67714/qAQe/+O2K1Mpl5n
         KLcgH9tUiZsg7ycC+c90N0+h8lsrVWP0PcfyeR3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0429/1039] octeontx2-af: Fix interrupt name strings
Date:   Mon, 24 Jan 2022 19:36:58 +0100
Message-Id: <20220124184139.716698050@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit 6dc9a23e29061e50c36523270de60039ccf536fa ]

Fixed interrupt name string logic which currently results
in wrong memory location being accessed while dumping
/proc/interrupts.

Fixes: 4826090719d4 ("octeontx2-af: Enable CPT HW interrupts")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/1641538505-28367-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c     | 5 ++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 45357deecabbf..a73a8017e0ee9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -172,14 +172,13 @@ static int cpt_10k_register_interrupts(struct rvu_block *block, int off)
 {
 	struct rvu *rvu = block->rvu;
 	int blkaddr = block->addr;
-	char irq_name[16];
 	int i, ret;
 
 	for (i = CPT_10K_AF_INT_VEC_FLT0; i < CPT_10K_AF_INT_VEC_RVU; i++) {
-		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		sprintf(&rvu->irq_name[(off + i) * NAME_SIZE], "CPTAF FLT%d", i);
 		ret = rvu_cpt_do_register_interrupt(block, off + i,
 						    rvu_cpt_af_flt_intr_handler,
-						    irq_name);
+						    &rvu->irq_name[(off + i) * NAME_SIZE]);
 		if (ret)
 			goto err;
 		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 70bacd38a6d9d..d0ab8f233a029 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -41,7 +41,7 @@ static bool rvu_common_request_irq(struct rvu *rvu, int offset,
 	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
 	int rc;
 
-	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], "%s", name);
 	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
 			 &rvu->irq_name[offset * NAME_SIZE], rvu_dl);
 	if (rc)
-- 
2.34.1




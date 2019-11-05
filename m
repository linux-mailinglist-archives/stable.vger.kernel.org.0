Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05658F06CB
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 21:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfKEUV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 15:21:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37124 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfKEUV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 15:21:26 -0500
Received: by mail-pl1-f193.google.com with SMTP id p13so10122514pll.4
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 12:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UcpbuCY2OBV0Wk2dNxkWEiuvm62F4+Nxy3MtNATh5QU=;
        b=Ec9M2m47tJ/A8Fp4WHurHd9eRUYK4zD5obbnbjZskxnwvFdzOtEOe+3MtDdzG8t7dT
         I3YazpFQiWfkiXYBtF/XBf7Qa6RFSuFW/Sp3GZ4M95nEprEo9YVkmF2Sj6WJOzON4bFc
         xjiGyf+efVQ6EwwrzNVHF3+lKCAZSwNi8QZwISW0ONWilrMK+wp6uEayqFBcBPB7UJrE
         IuHP7Z+5VJUZwRfR8cwDoYcrEnWzNEGknJZ4XVw1u/wjmw3iBhdHm4+/GW+G8P/YH7MS
         h1j3AEyfvqzrJnbbaRYOSV4XfcENwZnJDMSl9Z1FLz8cPmn3iwCfDidLvPtY661f/p0O
         TtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UcpbuCY2OBV0Wk2dNxkWEiuvm62F4+Nxy3MtNATh5QU=;
        b=YqB7Vfbm8+ypedWdlEJkfIDHTsoX0SUpp3NBH85XcbUgtIOaw1RmNE8tTdVGgHIfJO
         BlAmmJf6efF7ofWeWmdN5SD6jB17bikd8bKqd6OOJaT2Xu//Fg0PFcLv/pqAYPBNTlbd
         ClZrLFymSu9eb2GaB4Th5cDlEh11LoFcd+/R+171eX1hJHTHavb7FQKex47H+K2iyKSO
         ThDjBMUuJDC3OuKuMI+jFe/46KSiU71adqtWk0A8FwmnnKuofIZ5Fh979OCIM5cnXoG/
         j7azVGZg+Qy7IIIez7BdgV9svGfiOHy01IBQ6DD4xzsAp5ixk89WRs2PuW8nB15izOsY
         rGdQ==
X-Gm-Message-State: APjAAAVYY2FMarVod+7oj7TEjNynTFl4S+IBAaMQBkPSHXNgxVgsgXWc
        2sSfDntqGQMReDIkI3e+BqSejMuN
X-Google-Smtp-Source: APXvYqwIlY3qckxVLh8mqPRLGpnVP2nQiRAf3JiOuFPcoet3ULuHzqqQg+D7xfNFPveJ1bH5xaVMGQ==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr34184888plr.69.1572985286040;
        Tue, 05 Nov 2019 12:21:26 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 37sm17070871pgv.32.2019.11.05.12.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 12:21:25 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     stable@vger.kernel.org
Cc:     vkoul@kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH][STABLE backport 4.4] dmaengine: qcom: bam_dma: Fix resource leak
Date:   Tue,  5 Nov 2019 12:21:20 -0800
Message-Id: <20191105202120.28520-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 7667819385457b4aeb5fac94f67f52ab52cc10d5 upstream.

bam_dma_terminate_all() will leak resources if any of the transactions are
committed to the hardware (present in the desc fifo), and not complete.
Since bam_dma_terminate_all() does not cause the hardware to be updated,
the hardware will still operate on any previously committed transactions.
This can cause memory corruption if the memory for the transaction has been
reassigned, and will cause a sync issue between the BAM and its client(s).

Fix this by properly updating the hardware in bam_dma_terminate_all().

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191017152606.34120-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
Backported to 4.4 which is lacking 6b4faeac05bc
("dmaengine: qcom-bam: Process multiple pending descriptors")
---
 drivers/dma/qcom_bam_dma.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 5a250cdc8376..eca5b106d7d4 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -671,7 +671,21 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 
 	/* remove all transactions, including active transaction */
 	spin_lock_irqsave(&bchan->vc.lock, flag);
+	/*
+	 * If we have transactions queued, then some might be committed to the
+	 * hardware in the desc fifo.  The only way to reset the desc fifo is
+	 * to do a hardware reset (either by pipe or the entire block).
+	 * bam_chan_init_hw() will trigger a pipe reset, and also reinit the
+	 * pipe.  If the pipe is left disabled (default state after pipe reset)
+	 * and is accessed by a connected hardware engine, a fatal error in
+	 * the BAM will occur.  There is a small window where this could happen
+	 * with bam_chan_init_hw(), but it is assumed that the caller has
+	 * stopped activity on any attached hardware engine.  Make sure to do
+	 * this first so that the BAM hardware doesn't cause memory corruption
+	 * by accessing freed resources.
+	 */
 	if (bchan->curr_txd) {
+		bam_chan_init_hw(bchan, bchan->curr_txd->dir);
 		list_add(&bchan->curr_txd->vd.node, &bchan->vc.desc_issued);
 		bchan->curr_txd = NULL;
 	}
-- 
2.17.1


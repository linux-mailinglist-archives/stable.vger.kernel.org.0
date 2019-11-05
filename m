Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B299CF06B9
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 21:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfKEUOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 15:14:54 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46727 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfKEUOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 15:14:54 -0500
Received: by mail-pg1-f193.google.com with SMTP id f19so15164921pgn.13
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 12:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eDSfYyMrkTzRghvv2P7ORMxgfG1i1fq+Y4rRoFj0G50=;
        b=aNLDaH1Xjr/Qxruv9AL0w0Ulzn6YYF+Z67we/zK8h7lzt33eyHe+TPKyZMzadsHcFM
         oxypmR2NeO6EY//f1vL+V+KzHYZZfUp1gbaphgNWBJIzTfGEYjSKFoX69lnwyEsKFtEV
         oAsHQ+WwjfMTql4vRjLZrtLwKHeXWmFQ/gsvY6xBnFEg4K3e8sokkqwamPGqmX/hCP1V
         B7Khy/mtCyuJy0WZp0rZHN81WtIu2Z4c6liEsPNcnz9bXFDliAd4Dwpqi+kpFls2DVJe
         MO0k6oaLlwYL4gFWSNZRB82IEXdNGe387hTNtUykcwjLPtkcP31y2RE2v4nuP2gI9TUz
         vmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eDSfYyMrkTzRghvv2P7ORMxgfG1i1fq+Y4rRoFj0G50=;
        b=BuhDPDdtOXAJlkoquzGdP8nyI3lCDVtuQ5P0N0LwwwdGN+CDkBkoK+9u7rDb447ary
         dcpRYz69/gwl/qun2ciK0Gh7mcAfvVZ3DJ6JHA2c9ahm9g1fHycit+mP1kRRFFZ6wwC1
         Zl9Vk2NIIpnwCXsvWDuaoEfW5i67ulvejYyyuYZdFvOu86ERd2djdQQt+BivoL2F9Z0Q
         R1zWjPaaAUhdmVUDtszkxxaNskV09Ro+02i/Yo7iBefM4rOumQ1xAvKD7ILzh67DA//I
         asZnfVTi1AH4aN32zbB1yDWvnCYvlh17xX109jkmXNiLQBoiqUMbvMJx8OlRm8DKSfuA
         X0Bg==
X-Gm-Message-State: APjAAAUrwRiTqTbEUUS1P7GSHo8GRWSxzCkPTfYt0o4XobTgtSkSQGdB
        V0vuOsLJpZEDH3m0vGdg1ZYnl6uD
X-Google-Smtp-Source: APXvYqzsuBNxoz70UqeGu25kDYgFpiDlKXanBxZxmWCtN3XaScVZvUeVoBm4iYHD9jZrImftcE28Pw==
X-Received: by 2002:aa7:92c9:: with SMTP id k9mr40772748pfa.63.1572984892543;
        Tue, 05 Nov 2019 12:14:52 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id v3sm15512605pfi.26.2019.11.05.12.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 12:14:51 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     stable@vger.kernel.org
Cc:     vkoul@kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH][STABLE backport 4.14/4.9] dmaengine: qcom: bam_dma: Fix resource leak
Date:   Tue,  5 Nov 2019 12:14:42 -0800
Message-Id: <20191105201442.12477-1-jeffrey.l.hugo@gmail.com>
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
Backported to 4.14 which is lacking 6b4faeac05bc
("dmaengine: qcom-bam: Process multiple pending descriptors")
This version also applies to 4.9.
---
 drivers/dma/qcom/bam_dma.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8fbf175fdcc7..57c5cc51f862 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -690,7 +690,21 @@ static int bam_dma_terminate_all(struct dma_chan *chan)
 
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


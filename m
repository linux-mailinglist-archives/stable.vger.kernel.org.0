Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48B11AF53
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbfLKPMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfLKPMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E6524656;
        Wed, 11 Dec 2019 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077158;
        bh=h+zBRcu+AdqgyaGpfKBX70mO7TzpaplwLhg4eUDP5ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bccjxDHca+hglLSshUIct3/WgrH2u08YHs3slyfGTRZaVoLP3HPiH33bsJcWs9w/5
         gM7IZ3AgKwJhqSGvgEf3bGYa0Rl9a/bI8EfMkoWmidOOHiDuz8TPNcflVdFmnUN5GA
         SbApop/hbRp+VACBTs0MTNq+Y9GmOPhLvgVEv9iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 037/105] rsxx: add missed destroy_workqueue calls in remove
Date:   Wed, 11 Dec 2019 16:05:26 +0100
Message-Id: <20191211150234.404623500@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit dcb77e4b274b8f13ac6482dfb09160cd2fae9a40 ]

The driver misses calling destroy_workqueue in remove like what is done
when probe fails.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rsxx/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 76b73ddf8fd73..10f6368117d81 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -1000,8 +1000,10 @@ static void rsxx_pci_remove(struct pci_dev *dev)
 
 	cancel_work_sync(&card->event_work);
 
+	destroy_workqueue(card->event_wq);
 	rsxx_destroy_dev(card);
 	rsxx_dma_destroy(card);
+	destroy_workqueue(card->creg_ctrl.creg_wq);
 
 	spin_lock_irqsave(&card->irq_lock, flags);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
-- 
2.20.1




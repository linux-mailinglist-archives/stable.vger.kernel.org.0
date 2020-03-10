Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A4E17F93F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgCJMzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgCJMzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F07246B0;
        Tue, 10 Mar 2020 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844900;
        bh=boie7kjDXkrMgYA2kRh557Gzikic9mujKoVkRXup9ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGbT0Qr22ACdbPBVrPGCsZA+LAm1H40ojQOUM4hzDqqLRJ9xdIP8FHn9Fvmhl7wdQ
         8F+72v3/IC9m/siZC2hZVdNxzH2PrBdUNZMCs24BIKjRQS2p+yWamBgZiC+MRn1j98
         CSV8fgJe75q5Hm7U6Y/BlRpIg2BwjXKxJIYyjphU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 161/168] dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()
Date:   Tue, 10 Mar 2020 13:40:07 +0100
Message-Id: <20200310123651.841870478@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 36d5d22090d13fd3a7a8c9663a711cbe6970aac8 upstream.

The caller is already holding the lock so this will deadlock.

Fixes: 0b58828c923e ("DMAENGINE: COH 901 318 remove irq counting")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200217144050.3i4ymbytogod4ijn@kili.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/coh901318.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1947,8 +1947,6 @@ static void dma_tc_handle(struct coh9013
 		return;
 	}
 
-	spin_lock(&cohc->lock);
-
 	/*
 	 * When we reach this point, at least one queue item
 	 * should have been moved over from cohc->queue to
@@ -1969,8 +1967,6 @@ static void dma_tc_handle(struct coh9013
 	if (coh901318_queue_start(cohc) == NULL)
 		cohc->busy = 0;
 
-	spin_unlock(&cohc->lock);
-
 	/*
 	 * This tasklet will remove items from cohc->active
 	 * and thus terminates them.



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB3541CA8
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379282AbiFGWC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382401AbiFGVvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4A01B7825;
        Tue,  7 Jun 2022 12:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B292B823AE;
        Tue,  7 Jun 2022 19:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7485BC385A2;
        Tue,  7 Jun 2022 19:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628923;
        bh=aDXklFj4QxSRwAH8oeEkxX8UEqIXSQrOhWi8XCYMsRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydaur3CxA3/rG/xO148AFsW36+kGBEfQCO9zs+4h/qOrTl0nh9WV4BbAOxxvbLudz
         JWpKvTovxgODjXe0C9DhShLM75LxNqH6Xe4/N1EU4rS14F9xl5UgmPwKr1Wxaih7KA
         3QdAyc55cpjNTvm2EGQHheRdUjCTpJso8r24e7fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 465/879] nvme: set dma alignment to dword
Date:   Tue,  7 Jun 2022 18:59:43 +0200
Message-Id: <20220607165016.374006493@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 52fde2c07da606f3f120af4f734eadcfb52b04be ]

The nvme specification only requires qword alignment for segment
descriptors, and the driver already guarantees that. The spec has always
allowed user data to be dword aligned, which is what the queue's
attribute is for, so relax the alignment requirement to that value.

While we could allow byte alignment for some controllers when using
SGLs, we still need to support PRP, and that only allows dword.

Fixes: 3b2a1ebceba3 ("nvme: set dma alignment to qword")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ac32d1cd8477..2d6a01853109 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1771,7 +1771,7 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 		blk_queue_max_segments(q, min_t(u32, max_segments, USHRT_MAX));
 	}
 	blk_queue_virt_boundary(q, NVME_CTRL_PAGE_SIZE - 1);
-	blk_queue_dma_alignment(q, 7);
+	blk_queue_dma_alignment(q, 3);
 	blk_queue_write_cache(q, vwc, vwc);
 }
 
-- 
2.35.1




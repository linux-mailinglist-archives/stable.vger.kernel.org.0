Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B89541431
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358886AbiFGUOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359467AbiFGUNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:13:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A521C7EE3;
        Tue,  7 Jun 2022 11:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F2EDCE2439;
        Tue,  7 Jun 2022 18:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AED4C385A2;
        Tue,  7 Jun 2022 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626484;
        bh=kJImaIrTdnGNJWNnXYrajPYnP1GG0dHB5UOP8/EZ9G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WVvSGRTJK/6qfQ8GDresksAeu9JJ9BGAntzrNVoijJOiPxewBbhE478e/Lz3TDDW
         iHelC+nqXINAGb6v213kRzQsYpLrm5MXq5o7RGJ82oHH9hGSdoNXysVkvWzjEx5pJ1
         Yr8A0TFeFwkZxD3Vvvj1Qx3ulBGLvlPtkTmCtA8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 396/772] nvme: set dma alignment to dword
Date:   Tue,  7 Jun 2022 18:59:48 +0200
Message-Id: <20220607165000.680924542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 79ef46356d40..e086440a2042 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1796,7 +1796,7 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 		blk_queue_max_segments(q, min_t(u32, max_segments, USHRT_MAX));
 	}
 	blk_queue_virt_boundary(q, NVME_CTRL_PAGE_SIZE - 1);
-	blk_queue_dma_alignment(q, 7);
+	blk_queue_dma_alignment(q, 3);
 	blk_queue_write_cache(q, vwc, vwc);
 }
 
-- 
2.35.1




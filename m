Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B9660B8BB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiJXTxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbiJXTwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:52:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15C52ED78;
        Mon, 24 Oct 2022 11:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F407B8172C;
        Mon, 24 Oct 2022 12:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62994C433D7;
        Mon, 24 Oct 2022 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614906;
        bh=oZ77zsl4u0A1gtBdbEetr2d4Sa8iuGp2LRx82nWnImw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyDRwh33IiQkLOIXxjaMZVupzyLh8c5Dg5jjHFRKgVoub6b56gRVxIreFRBBWP33M
         4X2lfi22pkDnlmhWMmE7wwpf0MbRRb//Xt0Vg3rMyQ1akpnlme+ZuPSrqeHxaO7455
         L6XGyh5zB+4zpGWlMa/cTCKAaS25iWswwsCKKv/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rishabh Bhatnagar <risbhat@amazon.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 049/530] nvme-pci: set min_align_mask before calculating max_hw_sectors
Date:   Mon, 24 Oct 2022 13:26:33 +0200
Message-Id: <20221024113047.241431891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rishabh Bhatnagar <risbhat@amazon.com>

commit 61ce339f19fabbc3e51237148a7ef6f2270e44fa upstream.

If swiotlb is force enabled dma_max_mapping_size ends up calling
swiotlb_max_mapping_size which takes into account the min align mask for
the device.  Set the min align mask for nvme driver before calling
dma_max_mapping_size while calculating max hw sectors.

Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2732,6 +2732,8 @@ static void nvme_reset_work(struct work_
 	if (result)
 		goto out_unlock;
 
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
+
 	/*
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
@@ -2744,7 +2746,6 @@ static void nvme_reset_work(struct work_
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
-	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 



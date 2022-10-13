Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FFA5FE0A0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiJMSMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiJMSMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DEE16339A;
        Thu, 13 Oct 2022 11:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3202B820BD;
        Thu, 13 Oct 2022 18:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1154CC433C1;
        Thu, 13 Oct 2022 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684121;
        bh=7CXu2ISfdtjdID+KmuZSU74Aw/Of9Rg1gzLUSEkIXD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esBj9o9QwKUYW3HxyTi29nz33ostwSdLa3vB14kPwL69+zk/aetx9Rbu8YDaVheZg
         97V5emVVYhyb3u9AujXle0uovdOPVgm7+BcT2gxhu9d+rfxqMrWsSZX2PYfB8UhHDR
         DelxzRcHCvnK95Xf6VZkF5uuWE2TdB4muIQkeZ64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rishabh Bhatnagar <risbhat@amazon.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.0 05/34] nvme-pci: set min_align_mask before calculating max_hw_sectors
Date:   Thu, 13 Oct 2022 19:52:43 +0200
Message-Id: <20221013175146.661543716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -2834,6 +2834,8 @@ static void nvme_reset_work(struct work_
 		nvme_start_admin_queue(&dev->ctrl);
 	}
 
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
+
 	/*
 	 * Limit the max command size to prevent iod->sg allocations going
 	 * over a single page.
@@ -2846,7 +2848,6 @@ static void nvme_reset_work(struct work_
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
-	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8C7373A9F
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhEEML5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhEEMKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A942613F5;
        Wed,  5 May 2021 12:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216569;
        bh=S8RVvjfA1TBf24yMtHk/nvHbnU8yFOYwiTPItBWTCps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkqYP8jMw4IrC0vjQXctwpb+vgjnr3OM/WesrrB3CA3Sv8rtFQ8BLF99VoCrVxkNT
         DFpcP5lWdJvw/uWfH9Xanh/5PwJuy0hixBcZ4+zi72WIUg9MHCJpSOeKI5vEVb7Jm6
         ttPOc2S7iUdfXIHaalsQEurnIBn6qDjHZwRB6D/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianxiong Gao <jxgao@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5.11 21/31] nvme-pci: set min_align_mask
Date:   Wed,  5 May 2021 14:06:10 +0200
Message-Id: <20210505112327.370017023@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianxiong Gao <jxgao@google.com>

commit: 3d2d861eb03e8ee96dc430a54361c900cbe28afd

The PRP addressing scheme requires all PRP entries except for the
first one to have a zero offset into the NVMe controller pages (which
can be different from the Linux PAGE_SIZE).  Use the min_align_mask
device parameter to ensure that swiotlb does not change the address
of the buffer modulo the device page size to ensure that the PRPs
won't be malformed.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2629,6 +2629,7 @@ static void nvme_reset_work(struct work_
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 



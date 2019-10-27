Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB80E6755
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731627AbfJ0VUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbfJ0VUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:06 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3A462070B;
        Sun, 27 Oct 2019 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211206;
        bh=uEigrDSO+Ag3UVASUP0pmv4uqt7zouB0tEdl/zaUl3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RX799BkTP8NyaH18CgxZqQiX5vEF9LvWieD+Ep7VEuCwzp7+4KSgM5RlmcZYlIIRK
         2x7hzs9B43VnTg9g+tTiHlWKI2hKkeSZQqriq+hfcC3y+xP3vQfcOyCZR8t8BVJ6cF
         iKabs5m1GDdhuLiQoVICcN9T3xcTX+plHyqJnAko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Kevin Hao <haokexin@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.3 068/197] nvme-pci: Set the prp2 correctly when using more than 4k page
Date:   Sun, 27 Oct 2019 21:59:46 +0100
Message-Id: <20191027203355.327536227@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit a4f40484e7f1dff56bb9f286cc59ffa36e0259eb upstream.

In the current code, the nvme is using a fixed 4k PRP entry size,
but if the kernel use a page size which is more than 4k, we should
consider the situation that the bv_offset may be larger than the
dev->ctrl.page_size. Otherwise we may miss setting the prp2 and then
cause the command can't be executed correctly.

Fixes: dff824b2aadb ("nvme-pci: optimize mapping of small single segment requests")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -769,7 +769,8 @@ static blk_status_t nvme_setup_prp_simpl
 		struct bio_vec *bv)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	unsigned int first_prp_len = dev->ctrl.page_size - bv->bv_offset;
+	unsigned int offset = bv->bv_offset & (dev->ctrl.page_size - 1);
+	unsigned int first_prp_len = dev->ctrl.page_size - offset;
 
 	iod->first_dma = dma_map_bvec(dev->dev, bv, rq_dma_dir(req), 0);
 	if (dma_mapping_error(dev->dev, iod->first_dma))



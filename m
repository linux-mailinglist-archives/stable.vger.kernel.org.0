Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CBB37CCBB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhELQq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243439AbhELQlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE5561E46;
        Wed, 12 May 2021 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835454;
        bh=lIzSTWoTMrLRGgwJlo1EfEcmVMeaSwWFPEv7qGRKZIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN6N1oocW3IJfUBtRVuxLDhRw0I7i0ifuvlVJlbMG6fg5e/rVNyX303itRzMTXMJg
         DSQlzN0idDAWt33eSZUHI/mgenac8rA9g8NXUdV6REs2XUgZtTCfm0yTHMXOkZFUWh
         03ffrPvM4dCWJVQDhtXwR9UkH/RhJecked8VuIyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 352/677] media: saa7134: use sg_dma_len when building pgtable
Date:   Wed, 12 May 2021 16:46:38 +0200
Message-Id: <20210512144849.007739070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit 4e1cb753c04d74e06d7ca826ea0bcb02526af03e ]

The new AMD IOMMU DMA implementation concatenates sglist entries under
certain conditions, and because saa7134 accessed the length member
directly, it did not support this scenario.

This fixes IO_PAGE_FAULTs and choppy DMA audio by using the
sg_dma_len macro.

Fixes: be62dbf554c5 ("iommu/amd: Convert AMD iommu driver to the dma-iommu api")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 391572a6ec76..efb757d5168a 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -243,7 +243,7 @@ int saa7134_pgtable_build(struct pci_dev *pci, struct saa7134_pgtable *pt,
 
 	ptr = pt->cpu + startpage;
 	for (i = 0; i < length; i++, list = sg_next(list)) {
-		for (p = 0; p * 4096 < list->length; p++, ptr++)
+		for (p = 0; p * 4096 < sg_dma_len(list); p++, ptr++)
 			*ptr = cpu_to_le32(sg_dma_address(list) +
 						list->offset + p * 4096);
 	}
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A0437C8F2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbhELQOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239387AbhELQH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E018E61C57;
        Wed, 12 May 2021 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833863;
        bh=Ynh9hEgu0wzB5jLik9Ouq9QmfFGQBHYSgJQoXQfbRCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWDg6SZkj3+3BOw1cpTvyDNYrlJ27PtanRcHp6MGMp+g3bnuW+RhWk4wUbdrPGhnl
         Yw8TMdFtw7Y+mX2MzabQwiVIQ3meBTxUTNa+B3dwF4Grx1uh/qdvx6fn8J+xH8DG47
         GKxJR+p4MzaGjjjs/DiYwcgEVO2RfX0EkGQf4QHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tasos Sahanidis <tasos@tasossah.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 318/601] media: saa7146: use sg_dma_len when building pgtable
Date:   Wed, 12 May 2021 16:46:35 +0200
Message-Id: <20210512144838.287529086@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit e56429b09d5e0802b86f84ec7c24025886c9f88b ]

The new AMD IOMMU DMA implementation concatenates sglist entries under
certain conditions, and because saa7146 accessed the length member
directly, it did not support this scenario.

This fixes IO_PAGE_FAULTs by using the sg_dma_len macro.

Fixes: be62dbf554c5 ("iommu/amd: Convert AMD iommu driver to the dma-iommu api")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/saa7146/saa7146_core.c  | 2 +-
 drivers/media/common/saa7146/saa7146_video.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index f2d13b71416c..e50fa0ff7c5d 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -253,7 +253,7 @@ int saa7146_pgtable_build_single(struct pci_dev *pci, struct saa7146_pgtable *pt
 			 i, sg_dma_address(list), sg_dma_len(list),
 			 list->offset);
 */
-		for (p = 0; p * 4096 < list->length; p++, ptr++) {
+		for (p = 0; p * 4096 < sg_dma_len(list); p++, ptr++) {
 			*ptr = cpu_to_le32(sg_dma_address(list) + p * 4096);
 			nr_pages++;
 		}
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 7b8795eca589..66215d9106a4 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -247,9 +247,8 @@ static int saa7146_pgtable_build(struct saa7146_dev *dev, struct saa7146_buf *bu
 
 		/* walk all pages, copy all page addresses to ptr1 */
 		for (i = 0; i < length; i++, list++) {
-			for (p = 0; p * 4096 < list->length; p++, ptr1++) {
+			for (p = 0; p * 4096 < sg_dma_len(list); p++, ptr1++)
 				*ptr1 = cpu_to_le32(sg_dma_address(list) - list->offset);
-			}
 		}
 /*
 		ptr1 = pt1->cpu;
-- 
2.30.2




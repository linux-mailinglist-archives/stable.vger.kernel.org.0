Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA60667717
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbjALOjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbjALOjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:39:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783F262195
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CB5B8113E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7350DC433EF;
        Thu, 12 Jan 2023 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533736;
        bh=T68zxo0Ligk80wjw0xAUMp59YJHAh1xcbts/KLioVrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSL5Tjsqpu+JyUOqWSqycJYH0SHQf8ZpcmWYmIzmUrMqHbInr8kRx+bFaTW5K3ED1
         yxupTWZnzcNMmufrilngBC+EHhQ9N/8dOW2l0PnZOW6JukioZuv+RWN2fZdThhLEUO
         zvwMXRcA11wjbxRkJFHeP0BOa1YvL5bZb6L2orCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 576/783] nvme-pci: fix page size checks
Date:   Thu, 12 Jan 2023 14:54:52 +0100
Message-Id: <20230112135550.945916260@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 841734234a28fd5cd0889b84bd4d93a0988fa11e ]

The size allocated out of the dma pool is at most NVME_CTRL_PAGE_SIZE,
which may be smaller than the PAGE_SIZE.

Fixes: c61b82c7b7134 ("nvme-pci: fix PRP pool size")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 0452fb96df69..67dd68462b81 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -33,7 +33,7 @@
 #define SQ_SIZE(q)	((q)->q_depth << (q)->sqes)
 #define CQ_SIZE(q)	((q)->q_depth * sizeof(struct nvme_completion))
 
-#define SGES_PER_PAGE	(PAGE_SIZE / sizeof(struct nvme_sgl_desc))
+#define SGES_PER_PAGE	(NVME_CTRL_PAGE_SIZE / sizeof(struct nvme_sgl_desc))
 
 /*
  * These can be higher, but we need to ensure that any command doesn't
@@ -374,7 +374,7 @@ static int nvme_pci_npages_prp(void)
 {
 	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
 	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
-	return DIV_ROUND_UP(8 * nprps, PAGE_SIZE - 8);
+	return DIV_ROUND_UP(8 * nprps, NVME_CTRL_PAGE_SIZE - 8);
 }
 
 /*
@@ -384,7 +384,7 @@ static int nvme_pci_npages_prp(void)
 static int nvme_pci_npages_sgl(void)
 {
 	return DIV_ROUND_UP(NVME_MAX_SEGS * sizeof(struct nvme_sgl_desc),
-			PAGE_SIZE);
+			NVME_CTRL_PAGE_SIZE);
 }
 
 static size_t nvme_pci_iod_alloc_size(void)
@@ -735,7 +735,7 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 		sge->length = cpu_to_le32(entries * sizeof(*sge));
 		sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 	} else {
-		sge->length = cpu_to_le32(PAGE_SIZE);
+		sge->length = cpu_to_le32(NVME_CTRL_PAGE_SIZE);
 		sge->type = NVME_SGL_FMT_SEG_DESC << 4;
 	}
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FCA66C890
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjAPQkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjAPQj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:39:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B1D34555
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 749C8B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A9AC433D2;
        Mon, 16 Jan 2023 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886504;
        bh=9uBXOeVzhyTuWKKCov0/HHAz3bCgyXMB/6WXgpzKJRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOTUy1m3OWCNneG3+5YX4GYfasbLkYoj4qraOlbLED1KrDCDlP3PikJ6DiNll5Jao
         e0vL9icVF+a8SIo5fGGxSSefZByPzOIXTl7gojpw1PKaM2L7FCJ09GOmPllnGh3KPD
         UxpJH9uqtPgU0bpeg0ptgsxWk4aJafM5KsDmwuFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 456/658] nvme-pci: use the consistent return type of nvme_pci_iod_alloc_size()
Date:   Mon, 16 Jan 2023 16:49:04 +0100
Message-Id: <20230116154930.357767472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 9056fc9fc514ecd2457a59c575863ecb07c4fa5e ]

The nvme_pci_iod_alloc_size() should return 'size_t' type to be
consistent with the sizeof return value.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: c89a529e823d ("nvme-pci: fix mempool alloc size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c31fb6902c71..2b723d113bb3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -363,7 +363,7 @@ static int nvme_pci_npages_sgl(unsigned int num_seg)
 	return DIV_ROUND_UP(num_seg * sizeof(struct nvme_sgl_desc), PAGE_SIZE);
 }
 
-static unsigned int nvme_pci_iod_alloc_size(struct nvme_dev *dev,
+static size_t nvme_pci_iod_alloc_size(struct nvme_dev *dev,
 		unsigned int size, unsigned int nseg, bool use_sgl)
 {
 	size_t alloc_size;
-- 
2.35.1




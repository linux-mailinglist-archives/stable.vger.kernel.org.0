Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45D71A40F7
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgDJDrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgDJDrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6892820936;
        Fri, 10 Apr 2020 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490430;
        bh=bLaYknW8xJkpruAeW9vzpZ0HesbH5LKBqP1T/qNO/0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpNX1b4+gNmhfZDC9ZnBsCyojD4dgmKN3h47Nev24o113d3ZuYkiVyXSnSXSjZAFh
         QdZt5+fw1lKky2m0NenCG7Lo7PKXMqRpjyzHRCcCqJUq/wkQ4QoZQBFL5g+rMkin3Q
         2dwBmdFIt0oSqoOIzklMandP+ztg/v2mLzKdsmdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 28/68] dma-mapping: Fix dma_pgprot() for unencrypted coherent pages
Date:   Thu,  9 Apr 2020 23:45:53 -0400
Message-Id: <20200410034634.7731-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 17c4a2ae15a7aaefe84bdb271952678c5c9cd8e1 ]

When dma_mmap_coherent() sets up a mapping to unencrypted coherent memory
under SEV encryption and sometimes under SME encryption, it will actually
set up an encrypted mapping rather than an unencrypted, causing devices
that DMAs from that memory to read encrypted contents. Fix this.

When force_dma_unencrypted() returns true, the linear kernel map of the
coherent pages have had the encryption bit explicitly cleared and the
page content is unencrypted. Make sure that any additional PTEs we set
up to these pages also have the encryption bit cleared by having
dma_pgprot() return a protection with the encryption bit cleared in this
case.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20200304114527.3636-3-thomas_os@shipmail.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 12ff766ec1fa3..98e3d873792ea 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -154,6 +154,8 @@ EXPORT_SYMBOL(dma_get_sgtable_attrs);
  */
 pgprot_t dma_pgprot(struct device *dev, pgprot_t prot, unsigned long attrs)
 {
+	if (force_dma_unencrypted(dev))
+		prot = pgprot_decrypted(prot);
 	if (dev_is_dma_coherent(dev) ||
 	    (IS_ENABLED(CONFIG_DMA_NONCOHERENT_CACHE_SYNC) &&
              (attrs & DMA_ATTR_NON_CONSISTENT)))
-- 
2.20.1


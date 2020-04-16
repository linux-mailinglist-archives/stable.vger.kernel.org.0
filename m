Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527F31AC9F0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbgDPP31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897966AbgDPNnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EC72076D;
        Thu, 16 Apr 2020 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044631;
        bh=UnZbhbDBQCF/67WHGwIv0Ii6fJDazwVK16eoI7KevQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMi+RqX8qy/YEgRfGxOsjkIYV1XM8m/ijHdMVRSTzuhTAcnWS0c2VmW5+XxhR7MGL
         s4H8Ugs3NSQj9xEzpbwtATi5j6wjxYuIGPs0KeRCUayf4+6ZS5u5cU3HBkv2XPIFE4
         8EEXJL6tdxd9Lwz4wO1BczBObdIL2rKTBGNICKrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Borislav Petkov <bp@suse.de>, Christoph Hellwig <hch@lst.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/232] dma-mapping: Fix dma_pgprot() for unencrypted coherent pages
Date:   Thu, 16 Apr 2020 15:22:11 +0200
Message-Id: <20200416131320.574767415@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d9334f31a5afb..8682a5305cb36 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -169,6 +169,8 @@ EXPORT_SYMBOL(dma_get_sgtable_attrs);
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149F120E6B4
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404380AbgF2Vt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbgF2Sfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 834A121883;
        Mon, 29 Jun 2020 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444016;
        bh=i8qZhbIvdS30tcZvAuSwD6f39kDveI1mWIy+nCpRyL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUNvxRsQ2UYr8TVvMKi1H4Jlcu7P01JAZN4sP8zu9bPMdJ8nNWs3ny9eQQUlZlmDs
         rzeP/3vYUwP1mBUcXBvw+w8U+5BdE1h1lhpx8BvWJLs9xQrQBXzyo7vNmb6/aJ0DU8
         3wMdO1HEv6WQ5LtVXZcSdpwqXAc+oFAdoNm7ONKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 122/265] dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
Date:   Mon, 29 Jun 2020 11:15:55 -0400
Message-Id: <20200629151818.2493727-123-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

[ Upstream commit 96a539fa3bb71f443ae08e57b9f63d6e5bb2207c ]

If arch_dma_set_uncached() fails after memory has been decrypted, it needs
to be re-encrypted before freeing.

Fixes: fa7e2247c572 ("dma-direct: make uncached_kernel_address more general")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8f4bbdaf965eb..4e789c46ff0bf 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -186,7 +186,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		arch_dma_prep_coherent(page, size);
 		ret = arch_dma_set_uncached(ret, size);
 		if (IS_ERR(ret))
-			goto out_free_pages;
+			goto out_encrypt_pages;
 	}
 done:
 	if (force_dma_unencrypted(dev))
@@ -194,6 +194,11 @@ done:
 	else
 		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	return ret;
+
+out_encrypt_pages:
+	if (force_dma_unencrypted(dev))
+		set_memory_encrypted((unsigned long)page_address(page),
+				     1 << get_order(size));
 out_free_pages:
 	dma_free_contiguous(dev, page, size);
 	return NULL;
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6D720E75D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbgF2V4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CC2D246F7;
        Mon, 29 Jun 2020 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444039;
        bh=bLRl2rLPMhp83306SUIditzCcdXltvjcG8ReAqiFQ6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+eegtsCompvnv+dB1mCiMa0hUZmeY5IQK8Zs6o65t/Ing6yiWOAi6GoENy7WeX9D
         LaCifcoDeinUnEDeRAsvuCUqMjzLTl0FN9A1/10o/xy1+vj6J7ebA+2JZ9vxqgIP9S
         2kGf+gTSBCWxE/fufMlnu61/awYEunkeqI5dH0Do=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 146/265] dma-direct: add missing set_memory_decrypted() for coherent mapping
Date:   Mon, 29 Jun 2020 11:16:19 -0400
Message-Id: <20200629151818.2493727-147-sashal@kernel.org>
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

[ Upstream commit 1a2b3357e860d890f8045367b179c7e7e802cd71 ]

When a coherent mapping is created in dma_direct_alloc_pages(), it needs
to be decrypted if the device requires unencrypted DMA before returning.

Fixes: 3acac065508f ("dma-mapping: merge the generic remapping helpers into dma-direct")
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 98c445dcb308b..2270930f36f83 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -161,6 +161,12 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 				__builtin_return_address(0));
 		if (!ret)
 			goto out_free_pages;
+		if (force_dma_unencrypted(dev)) {
+			err = set_memory_decrypted((unsigned long)ret,
+						   1 << get_order(size));
+			if (err)
+				goto out_free_pages;
+		}
 		memset(ret, 0, size);
 		goto done;
 	}
-- 
2.25.1


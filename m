Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F1415666
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhIWDlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239356AbhIWDkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D776121F;
        Thu, 23 Sep 2021 03:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368349;
        bh=BJnQJGKsBsmbmS6kpbj/l8IiwogKaf4AYawUXj+cxEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URtvXQlWMuvgGG0LIq+yrkmp7pb2/+RIvLiHYuTgiNxDiJoDvS0bGpsKX/CKWloWM
         +yJr2lMNg/ltAw38VhOJ3yIY+WECdydnxvNVktLejrPcgY2aXOogicEqpwvR29p1Pq
         fx9bT8yom2AiLZKao2YvraU7sqR1+pvN5Lr174HHlNYO72g5jhTz4SfwrA4R/AHpcC
         OMNQok4OwJQw2gfNm6MyREFKuDIHtUAIzCD2pBg0kXuCYri8X+ZRKU7QvA3js8Thro
         nknOjqyJ4TB7RwO9QvuJR+hzbVUO+w6jGKPhel8NFEeF1RzldWml3TbCU4W0HqNX/I
         +LlE0bjnsagIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Larsson <andreas@gaisler.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/19] sparc32: page align size in arch_dma_alloc
Date:   Wed, 22 Sep 2021 23:38:43 -0400
Message-Id: <20210923033853.1421193-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033853.1421193-1-sashal@kernel.org>
References: <20210923033853.1421193-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit 59583f747664046aaae5588d56d5954fab66cce8 ]

Commit 53b7670e5735 ("sparc: factor the dma coherent mapping into
helper") lost the page align for the calls to dma_make_coherent and
srmmu_unmapiorange. The latter cannot handle a non page aligned len
argument.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/ioport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index f89603855f1e..b87e0002131d 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -356,7 +356,9 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs)
 {
-	if (!sparc_dma_free_resource(cpu_addr, PAGE_ALIGN(size)))
+	size = PAGE_ALIGN(size);
+
+	if (!sparc_dma_free_resource(cpu_addr, size))
 		return;
 
 	dma_make_coherent(dma_addr, size);
-- 
2.30.2


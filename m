Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEC8137F24
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgAKKQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgAKKQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:16:53 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17AC20848;
        Sat, 11 Jan 2020 10:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737812;
        bh=MYIIQKf/tlrqyLKCFLb0w3uYjfXyqxZTHrF8jHYL8dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlG3++tO+ZYwrtnezKx52OzGKb5gtKGeVinZcb/z5YGgzNxHZkAGLTFZRmQKm6gi7
         zrYgIKrmWHJ6JvQd+JAdpt9c6fsZPb2uhWCaA7QsDCF0xNn5jGDM0VLKg0xGbz8H7d
         SvDhHUZJ3CfwmfHsBFN3Waw14Js0ch3QvcgHk/EE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/84] powerpc: Ensure that swiotlb buffer is allocated from low memory
Date:   Sat, 11 Jan 2020 10:50:10 +0100
Message-Id: <20200111094858.774120262@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit 8fabc623238e68b3ac63c0dd1657bf86c1fa33af ]

Some powerpc platforms (e.g. 85xx) limit DMA-able memory way below 4G.
If a system has more physical memory than this limit, the swiotlb
buffer is not addressable because it is allocated from memblock using
top-down mode.

Force memblock to bottom-up mode before calling swiotlb_init() to
ensure that the swiotlb buffer is DMA-able.

Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191204123524.22919-1-rppt@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/mem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 04ccb274a620..9a6afd9f3f9b 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -344,6 +344,14 @@ void __init mem_init(void)
 	BUILD_BUG_ON(MMU_PAGE_COUNT > 16);
 
 #ifdef CONFIG_SWIOTLB
+	/*
+	 * Some platforms (e.g. 85xx) limit DMA-able memory way below
+	 * 4G. We force memblock to bottom-up mode to ensure that the
+	 * memory allocated in swiotlb_init() is DMA-able.
+	 * As it's the last memblock allocation, no need to reset it
+	 * back to to-down.
+	 */
+	memblock_set_bottom_up(true);
 	swiotlb_init(0);
 #endif
 
-- 
2.20.1




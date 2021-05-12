Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DDB37CD8F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbhELQ4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243975AbhELQmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF7761CF7;
        Wed, 12 May 2021 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835746;
        bh=taiSfcW3kBV8bXDhVoywPmuDC0TJiQjiM7raHel3s+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/VON5x/4GbqIAs76uinMeA5MgOY8I38aL56ICpWQ5U9Dx8e5s/BKPsf6qlqqFz/r
         Rq5yiuqkpXyodlDIOXq54UbMDpoGLWXA0yJuZBRKTjvv9PyaoZfaOzsS6medW7KYc/
         qTvrKO/vzvNUpplJlCUJHVdbCgO3FIrff2YH0bHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 468/677] MIPS: loongson64: fix bug when PAGE_SIZE > 16KB
Date:   Wed, 12 May 2021 16:48:34 +0200
Message-Id: <20210512144852.911877664@linuxfoundation.org>
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

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit 509d36a941a3466b78d4377913623d210b162458 ]

When page size larger than 16KB, arguments "vaddr + size(16KB)" in
"ioremap_page_range(vaddr, vaddr + size,...)" called by
"add_legacy_isa_io" is not page-aligned.

As loongson64 needs at least page size 16KB to get rid of cache alias,
and "vaddr" is 64KB-aligned, and 64KB is largest page size supported,
rounding "size" up to PAGE_SIZE is enough for all page size supported.

Fixes: 6d0068ad15e4 ("MIPS: Loongson64: Process ISA Node in DeviceTree")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/loongson64/init.c b/arch/mips/loongson64/init.c
index cfa788bca871..1c664b23c0f9 100644
--- a/arch/mips/loongson64/init.c
+++ b/arch/mips/loongson64/init.c
@@ -126,7 +126,7 @@ static int __init add_legacy_isa_io(struct fwnode_handle *fwnode, resource_size_
 		return -ENOMEM;
 
 	range->fwnode = fwnode;
-	range->size = size;
+	range->size = size = round_up(size, PAGE_SIZE);
 	range->hw_start = hw_start;
 	range->flags = LOGIC_PIO_CPU_MMIO;
 
-- 
2.30.2




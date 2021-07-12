Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A703C4774
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhGLGcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235943AbhGLG3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1181261176;
        Mon, 12 Jul 2021 06:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071172;
        bh=v1CNQHHDbDUywzruPg+VhAFq08QX8RgX71SQf5Xsgr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hdx6ecWQXNtxO8WuoqY78RUAjEfhAZtnYfjsOQmG2EbLnUH4gd4IMZUyolZPxXUe8
         XI4s2Bgja7zdW/PXTp+c2HRgN0eDwjrjLthVnwva2m7Kw+nCV6/Mp7EcBbUCLuPZ2M
         X/N3sTpceBw/77b3ireyTcciaqRmizYVnHnwgUMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/348] MIPS: Fix PKMAP with 32-bit MIPS huge page support
Date:   Mon, 12 Jul 2021 08:10:37 +0200
Message-Id: <20210712060736.313624382@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit cf02ce742f09188272bcc8b0e62d789eb671fc4c ]

When 32-bit MIPS huge page support is enabled, we halve the number of
pointers a PTE page holds, making its last half go to waste.
Correspondingly, we should halve the number of kmap entries, as we just
initialized only a single pte table for that in pagetable_init().

Fixes: 35476311e529 ("MIPS: Add partial 32-bit huge page support")
Signed-off-by: Wei Li <liwei391@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/highmem.h b/arch/mips/include/asm/highmem.h
index 9d84aafc33d0..9a6bf4f011b5 100644
--- a/arch/mips/include/asm/highmem.h
+++ b/arch/mips/include/asm/highmem.h
@@ -36,7 +36,7 @@ extern pte_t *pkmap_page_table;
  * easily, subsequent pte tables have to be allocated in one physical
  * chunk of RAM.
  */
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
+#if defined(CONFIG_PHYS_ADDR_T_64BIT) || defined(CONFIG_MIPS_HUGE_TLB_SUPPORT)
 #define LAST_PKMAP 512
 #else
 #define LAST_PKMAP 1024
-- 
2.30.2




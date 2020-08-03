Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6849923A65D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgHCMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgHCMZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A004204EC;
        Mon,  3 Aug 2020 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457535;
        bh=O8sbMn7Pvn99MTZ61vvAbPtt75NieU4YRkG3Qh3NqLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxIvyPoLTjwB5W0QEwgX9GyVmXLWKbpW0zBOAwEgbi2SNXO8kZQMGPqSUiDZqJMbS
         5U3hViEXyHArpLHbrCdx6PRpx54yOZgcBn6XTkH/ASIBeifjVNpAy/luAsHeGa5H2J
         +NkzTIpFWcq7j1yvE6GrQwk/6yHq+MoY0fDGpcfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 104/120] riscv: kasan: use local_tlb_flush_all() to avoid uninitialized __sbi_rfence
Date:   Mon,  3 Aug 2020 14:19:22 +0200
Message-Id: <20200803121907.971298113@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit 4cb699d0447be8e0906539f93cbe41e19598ee5a ]

It fails to boot the v5.8-rc4 kernel with CONFIG_KASAN because kasan_init
and kasan_early_init use uninitialized __sbi_rfence as executing the
tlb_flush_all(). Actually, at this moment, only the CPU which is
responsible for the system initialization enables the MMU. Other CPUs are
parking at the .Lsecondary_start. Hence the tlb_flush_all() is able to be
replaced by local_tlb_flush_all() to avoid using uninitialized
__sbi_rfence.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/mm/kasan_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index ec0ca90dd9000..7a580c8ad6034 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -44,7 +44,7 @@ asmlinkage void __init kasan_early_init(void)
 				(__pa(((uintptr_t) kasan_early_shadow_pmd))),
 				__pgprot(_PAGE_TABLE)));
 
-	flush_tlb_all();
+	local_flush_tlb_all();
 }
 
 static void __init populate(void *start, void *end)
@@ -79,7 +79,7 @@ static void __init populate(void *start, void *end)
 			pfn_pgd(PFN_DOWN(__pa(&pmd[offset])),
 				__pgprot(_PAGE_TABLE)));
 
-	flush_tlb_all();
+	local_flush_tlb_all();
 	memset(start, 0, end - start);
 }
 
-- 
2.25.1




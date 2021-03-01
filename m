Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34A328428
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhCAQ36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:29:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234383AbhCAQ0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:26:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E729A64F4A;
        Mon,  1 Mar 2021 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615713;
        bh=mrU0jcKrb7TALDN/P6iAXgazLGXjWh9OU6ExnpesbI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7xAYjm8lXvSlecOwGBlRMpOxwMu6CWaawGYCVKRd1f/I/uSt/uh+aIA9MCshBi/Z
         3CNHQv8CaGZ55jrAnJufj6asN3+Kwa6i/MdYVszojWneLIx2n2Kn2u6sIRLrcgEeQR
         aMxJK43AA6iv7wqUo0qenA6PCFTa9cDpH2AodTtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/134] MIPS: c-r4k: Fix section mismatch for loongson2_sc_init
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161015.160167753@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit c58734eee6a2151ba033c0dcb31902c89e310374 ]

When building with clang, the following section mismatch warning occurs:

WARNING: modpost: vmlinux.o(.text+0x24490): Section mismatch in
reference from the function r4k_cache_init() to the function
.init.text:loongson2_sc_init()

This should have been fixed with commit ad4fddef5f23 ("mips: fix Section
mismatch in reference") but it was missed. Remove the improper __init
annotation like that commit did.

Fixes: 078a55fc824c ("MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code")
Link: https://github.com/ClangBuiltLinux/linux/issues/787
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/c-r4k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index cb877f86f5fc9..b9dea4ce290c1 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1630,7 +1630,7 @@ static int probe_scache(void)
 	return 1;
 }
 
-static void __init loongson2_sc_init(void)
+static void loongson2_sc_init(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 
-- 
2.27.0




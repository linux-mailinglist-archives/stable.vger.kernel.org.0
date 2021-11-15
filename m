Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F245146A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349224AbhKOUFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344354AbhKOTYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB236366B;
        Mon, 15 Nov 2021 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002575;
        bh=+7Yw0/uD2q8RPOwNfAd3r3Ux8OqWoYp+JSP1sPITtDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgUP5Q5vQ1oxDzKl7G8cDecKwLw6y/9t9Woqu8c1B9attSs5xXSps9U2K1yzXjeWr
         XVumK1gJdPU683ACwYhvqyIfTeoT2qA/h1ToStsP5MG9ZTFsBdcMggUa4uDIEmaAJo
         Jaw88Bw7SmHarHUlodcaxeaWqfpglVzkjN+Fafag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 619/917] powerpc/mem: Fix arch/powerpc/mm/mem.c:53:12: error: no previous prototype for create_section_mapping
Date:   Mon, 15 Nov 2021 18:01:54 +0100
Message-Id: <20211115165449.787812878@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7eff9bc00ddf1e2281dff575884b7f676c85b006 ]

Commit 8e11d62e2e87 ("powerpc/mem: Add back missing header to fix 'no
previous prototype' error") was supposed to fix the problem, but in
the meantime commit a927bd6ba952 ("mm: fix phys_to_target_node() and*
memory_add_physaddr_to_nid() exports") moved create_section_mapping()
prototype from asm/sparsemem.h to asm/mmzone.h

Fixes: 8e11d62e2e87 ("powerpc/mem: Add back missing header to fix 'no previous prototype' error")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/025754fde3d027904ae9d0191f395890bec93369.1631541649.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index c3c4e31462eca..05b9c3f31456c 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -20,8 +20,8 @@
 #include <asm/machdep.h>
 #include <asm/rtas.h>
 #include <asm/kasan.h>
-#include <asm/sparsemem.h>
 #include <asm/svm.h>
+#include <asm/mmzone.h>
 
 #include <mm/mmu_decl.h>
 
-- 
2.33.0




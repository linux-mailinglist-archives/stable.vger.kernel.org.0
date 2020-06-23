Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0118720639A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390932AbgFWU27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390461AbgFWU24 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331D3206C3;
        Tue, 23 Jun 2020 20:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944135;
        bh=i3jueepplDkNuk9wE4egerL1INGsMUlzWA2rMOMR2J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHOnciaO2F1Os8xgH1bt3frlqdvdQUGt+g82k8+x8pA8tcI5zDfhX6tSrhap0TvIt
         Gv1dxF0H1YJ+H3Bgs5pkpr4mVY8W4WiMFaojobPfNlT+ZyJXi1U21ypSQYGTO4xwyo
         Fp8pGGpxxla0CA4ZHFormbFXK0aB3Vssl+7dNT4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/314] powerpc/32s: Dont warn when mapping RO data ROX.
Date:   Tue, 23 Jun 2020 21:56:21 +0200
Message-Id: <20200623195347.776815416@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 4b19f96a81bceaf0bcf44d79c0855c61158065ec ]

Mapping RO data as ROX is not an issue since that data
cannot be modified to introduce an exploit.

PPC64 accepts to have RO data mapped ROX, as a trade off
between kernel size and strictness of protection.

On PPC32, kernel size is even more critical as amount of
memory is usually small.

Depending on the number of available IBATs, the last IBATs
might overflow the end of text. Only warn if it crosses
the end of RO data.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/6499f8eeb2a36330e5c9fc1cee9a79374875bd54.1589866984.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s32/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 84d5fab94f8f8..1424a120710e4 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -187,6 +187,7 @@ void mmu_mark_initmem_nx(void)
 	int i;
 	unsigned long base = (unsigned long)_stext - PAGE_OFFSET;
 	unsigned long top = (unsigned long)_etext - PAGE_OFFSET;
+	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
 	unsigned long size;
 
 	if (IS_ENABLED(CONFIG_PPC_BOOK3S_601))
@@ -201,9 +202,10 @@ void mmu_mark_initmem_nx(void)
 		size = block_size(base, top);
 		size = max(size, 128UL << 10);
 		if ((top - base) > size) {
-			if (strict_kernel_rwx_enabled())
-				pr_warn("Kernel _etext not properly aligned\n");
 			size <<= 1;
+			if (strict_kernel_rwx_enabled() && base + size > border)
+				pr_warn("Some RW data is getting mapped X. "
+					"Adjust CONFIG_DATA_SHIFT to avoid that.\n");
 		}
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
-- 
2.25.1




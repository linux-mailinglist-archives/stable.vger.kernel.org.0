Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1890411CD4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbhITRNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347179AbhITRLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6798D61222;
        Mon, 20 Sep 2021 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157030;
        bh=/y3FPnQS+tkbP77dbXYk2EbQGbfoE6zS1rJ+5CSX1/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnQC4gP3tKW0lbK8H8Gddxoy/k2R08N9Ahf7d11MZZxA3n6g66928+1gPItAOjUfO
         XwK5BddmQ8uq6ivybg9/OsLStsgILiGQmWoLkNWLjGGrwBwfx47QfYfN6YX9nQjC/u
         J09qLR/0gKCx9KjJhvVAIU3A1a+SwaC/roVqpSY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 021/217] powerpc/module64: Fix comment in R_PPC64_ENTRY handling
Date:   Mon, 20 Sep 2021 18:40:42 +0200
Message-Id: <20210920163925.332820779@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 2fb0a2c989837c976b68233496bbaefb47cd3d6f upstream.

The comment here is wrong, the addi reads from r2 not r12. The code is
correct, 0x38420000 = addi r2,r2,0.

Fixes: a61674bdfc7c ("powerpc/module: Handle R_PPC64_ENTRY relocations")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/module_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -695,7 +695,7 @@ int apply_relocate_add(Elf64_Shdr *sechd
 			/*
 			 * If found, replace it with:
 			 *	addis r2, r12, (.TOC.-func)@ha
-			 *	addi r2, r12, (.TOC.-func)@l
+			 *	addi  r2,  r2, (.TOC.-func)@l
 			 */
 			((uint32_t *)location)[0] = 0x3c4c0000 + PPC_HA(value);
 			((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);



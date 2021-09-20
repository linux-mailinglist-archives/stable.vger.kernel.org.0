Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC3D411A4E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbhITQsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243629AbhITQsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A27960F6E;
        Mon, 20 Sep 2021 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156395;
        bh=QmEUPYvCs278HOHIsmLUGKG7TGSEj1b5a3hRAh4XEZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tfu3SR71oLojoVV/SBPXTXWsg7EDwSEpM3na3fm9Z5haz+CLW/0s/YqhAqDs27DKB
         AkMGucsLUExYaNp12Lx98oT8QLJ8gK3FXbbHz7va+GVz8Cf9hH8lDivBCbynwc4yP6
         my4tR/ZzwV1BitAJqrZTwIgfa+LV4OMWCgBHTqFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 022/133] powerpc/module64: Fix comment in R_PPC64_ENTRY handling
Date:   Mon, 20 Sep 2021 18:41:40 +0200
Message-Id: <20210920163913.337481283@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -662,7 +662,7 @@ int apply_relocate_add(Elf64_Shdr *sechd
 			/*
 			 * If found, replace it with:
 			 *	addis r2, r12, (.TOC.-func)@ha
-			 *	addi r2, r12, (.TOC.-func)@l
+			 *	addi  r2,  r2, (.TOC.-func)@l
 			 */
 			((uint32_t *)location)[0] = 0x3c4c0000 + PPC_HA(value);
 			((uint32_t *)location)[1] = 0x38420000 + PPC_LO(value);



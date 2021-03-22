Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB93441B8
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhCVMfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230456AbhCVMeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6969619A4;
        Mon, 22 Mar 2021 12:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416453;
        bh=VZIqVvkCVuJLiNv0BfZI5hYRYtAVEGfHzcGbouT0SSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pn5ZjBKSMaX6Y3oHZlO6QKl+5MuA9mEr8SPtxn5RF54qVePqdKvFFXJ7fThzioLgv
         31QzOXv3WK9xRn3ZBzmnnfBoadNsgxNdY3nUEVbOhTVFiXqmaqlyeRbZSlHCLV0mh/
         zBGHjRHSAicC7KQme2KQ+63as5gJeAneXX8wV5HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 077/120] powerpc: Force inlining of cpu_has_feature() to avoid build failure
Date:   Mon, 22 Mar 2021 13:27:40 +0100
Message-Id: <20210322121932.247267327@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit eed5fae00593ab9d261a0c1ffc1bdb786a87a55a upstream.

The code relies on constant folding of cpu_has_feature() based
on possible and always true values as defined per
CPU_FTRS_ALWAYS and CPU_FTRS_POSSIBLE.

Build failure is encountered with for instance
book3e_all_defconfig on kisskb in the AMDGPU driver which uses
cpu_has_feature(CPU_FTR_VSX_COMP) to decide whether calling
kernel_enable_vsx() or not.

The failure is due to cpu_has_feature() not being inlined with
that configuration with gcc 4.9.

In the same way as commit acdad8fb4a15 ("powerpc: Force inlining of
mmu_has_feature to fix build failure"), for inlining of
cpu_has_feature().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b231dfa040ce4cc37f702f5c3a595fdeabfe0462.1615378209.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/cpu_has_feature.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/cpu_has_feature.h
+++ b/arch/powerpc/include/asm/cpu_has_feature.h
@@ -7,7 +7,7 @@
 #include <linux/bug.h>
 #include <asm/cputable.h>
 
-static inline bool early_cpu_has_feature(unsigned long feature)
+static __always_inline bool early_cpu_has_feature(unsigned long feature)
 {
 	return !!((CPU_FTRS_ALWAYS & feature) ||
 		  (CPU_FTRS_POSSIBLE & cur_cpu_spec->cpu_features & feature));
@@ -46,7 +46,7 @@ static __always_inline bool cpu_has_feat
 	return static_branch_likely(&cpu_feature_keys[i]);
 }
 #else
-static inline bool cpu_has_feature(unsigned long feature)
+static __always_inline bool cpu_has_feature(unsigned long feature)
 {
 	return early_cpu_has_feature(feature);
 }



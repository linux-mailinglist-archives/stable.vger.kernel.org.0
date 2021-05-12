Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3707F37C9C1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhELQVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239986AbhELQQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D1A61D62;
        Wed, 12 May 2021 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834187;
        bh=s7GYJLD9H2ET5g+aXU4rGsR/doxp68Fju7SWvx9sD6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBbS3hlnc8P+dSEbdgk9Y/zQoHonu8nD6cePxhNbpBGjZxNvYuJyEBzBju1jz8r12
         N+nSfcfI8oW59OE/rZahMB0yMwdShBrtIbBrMB+rEw6A1ZHls9c/v8WKEmiZSdCkwM
         qoW8DDpsscU0yge2cSVLqGaOs2ycwCDsj27jjAIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 408/601] powerpc/fadump: Mark fadump_calculate_reserve_size as __init
Date:   Wed, 12 May 2021 16:48:05 +0200
Message-Id: <20210512144841.268839292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fbced1546eaaab57a32e56c974ea8acf10c6abd8 ]

If fadump_calculate_reserve_size() is not inlined, there is a modpost
warning:

WARNING: modpost: vmlinux.o(.text+0x5196c): Section mismatch in
reference from the function fadump_calculate_reserve_size() to the
function .init.text:parse_crashkernel()
The function fadump_calculate_reserve_size() references
the function __init parse_crashkernel().
This is often because fadump_calculate_reserve_size lacks a __init
annotation or the annotation of parse_crashkernel is wrong.

fadump_calculate_reserve_size() calls parse_crashkernel(), which is
marked as __init and fadump_calculate_reserve_size() is called from
within fadump_reserve_mem(), which is also marked as __init.

Mark fadump_calculate_reserve_size() as __init to fix the section
mismatch. Additionally, remove the inline keyword as it is not necessary
to inline this function; the compiler is still free to do so if it feels
it is worthwhile since commit 889b3c1245de ("compiler: remove
CONFIG_OPTIMIZE_INLINING entirely").

Fixes: 11550dc0a00b ("powerpc/fadump: reuse crashkernel parameter for fadump memory reservation")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/ClangBuiltLinux/linux/issues/1300
Link: https://lore.kernel.org/r/20210302195013.2626335-1-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 8482739d42f3..eddf362caedc 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -292,7 +292,7 @@ static void fadump_show_config(void)
  * that is required for a kernel to boot successfully.
  *
  */
-static inline u64 fadump_calculate_reserve_size(void)
+static __init u64 fadump_calculate_reserve_size(void)
 {
 	u64 base, size, bootmem_min;
 	int ret;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0246A2E3FA5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506306AbgL1Omi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:42:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502321AbgL1O1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260E822B3B;
        Mon, 28 Dec 2020 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165616;
        bh=jsXIYmTeoZcSyAe/wWWFr28PMJlixSJ1U0qNOZYhKUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUup/evK+yO8p/XW6C26QLNnB0lh8o1nR14XkFh/o8TAApmho1bgZbtAINX8LF4JL
         3m4sG9e+svt0eyJB3a4pAFpiaJoVX6WqVVxJNG99UiFqN8c1mmagSwr2B38BInefTt
         GNuvS3Wb56B2EMxRqjsPWGMpm95HPHqCiWcgkhVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bin.meng@windriver.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 594/717] RISC-V: Fix usage of memblock_enforce_memory_limit
Date:   Mon, 28 Dec 2020 13:49:52 +0100
Message-Id: <20201228125049.370627127@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

commit de043da0b9e71147ca610ed542d34858aadfc61c upstream.

memblock_enforce_memory_limit accepts the maximum memory size not the
maximum address that can be handled by kernel. Fix the function invocation
accordingly.

Fixes: 1bd14a66ee52 ("RISC-V: Remove any memblock representing unusable memory area")
Cc: stable@vger.kernel.org
Reported-by: Bin Meng <bin.meng@windriver.com>
Tested-by: Bin Meng <bin.meng@windriver.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -174,7 +174,7 @@ void __init setup_bootmem(void)
 	 * Make sure that any memory beyond mem_start + (-PAGE_OFFSET) is removed
 	 * as it is unusable by kernel.
 	 */
-	memblock_enforce_memory_limit(mem_start - PAGE_OFFSET);
+	memblock_enforce_memory_limit(-PAGE_OFFSET);
 
 	/* Reserve from the start of the kernel to the end of the kernel */
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);



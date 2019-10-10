Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C64FD25CF
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387633AbfJJIid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfJJIia (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F9820B7C;
        Thu, 10 Oct 2019 08:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696710;
        bh=Y/QyNHs1wlYM1xMfQDCExXh+qkkSoISEJqkmaUOHBMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hshTWCovWok4V9fGNKHRwlSQ2sKP4wJVm7sHEQabuTlsaCuwI5/hjPgR7Dnkmed0C
         HgGk20XNq/xUeiJ8wZHI6J6orydooIIK9Ortcw9YiVz/UApPlO3Db3P/kwtNMeMIQe
         W7vp1e0u46VnfnZr30/UIXMY3jqodEKRSNVStM3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Doug Crawford <doug.crawford@intelight-its.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 024/148] powerpc/603: Fix handling of the DIRTY flag
Date:   Thu, 10 Oct 2019 10:34:45 +0200
Message-Id: <20191010083612.586850852@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 415480dce2ef03bb8335deebd2f402f475443ce0 upstream.

If a page is already mapped RW without the DIRTY flag, the DIRTY
flag is never set and a TLB store miss exception is taken forever.

This is easily reproduced with the following app:

void main(void)
{
	volatile char *ptr = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);

	*ptr = *ptr;
}

When DIRTY flag is not set, bail out of TLB miss handler and take
a minor page fault which will set the DIRTY flag.

Fixes: f8b58c64eaef ("powerpc/603: let's handle PAGE_DIRTY directly")
Cc: stable@vger.kernel.org # v5.1+
Reported-by: Doug Crawford <doug.crawford@intelight-its.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/80432f71194d7ee75b2f5043ecf1501cf1cca1f3.1566196646.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -557,9 +557,9 @@ DataStoreTLBMiss:
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
 #ifdef CONFIG_SWAP
-	li	r1, _PAGE_RW | _PAGE_PRESENT | _PAGE_ACCESSED
+	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
 #else
-	li	r1, _PAGE_RW | _PAGE_PRESENT
+	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT
 #endif
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */



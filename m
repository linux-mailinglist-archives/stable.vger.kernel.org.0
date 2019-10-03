Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55B8CA7C4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392411AbfJCQut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404623AbfJCQut (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B768721783;
        Thu,  3 Oct 2019 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121448;
        bh=60vSsisF/vTpEUWXN2OtyUqye/8pSQ8hFzP0MuHfmlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7+9x9lX7Lq505w6XsY0Wx0O15kEmsksr3+X46veaAt4O+PCGGa2FZh27jMSnm223
         DVZ/VXFtu887Xgh4+LM/M/ma28ioktyvtqm/UkYZgTT0lmOhnoYfUB64Ss7CpGaQe5
         S78u+LM2G5Uy49XkGnIm3OhSm9xD1NGQZWGz3KkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.3 282/344] arm64: tlb: Ensure we execute an ISB following walk cache invalidation
Date:   Thu,  3 Oct 2019 17:54:07 +0200
Message-Id: <20191003154607.775075179@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit 51696d346c49c6cf4f29e9b20d6e15832a2e3408 upstream.

05f2d2f83b5a ("arm64: tlbflush: Introduce __flush_tlb_kernel_pgtable")
added a new TLB invalidation helper which is used when freeing
intermediate levels of page table used for kernel mappings, but is
missing the required ISB instruction after completion of the TLBI
instruction.

Add the missing barrier.

Cc: <stable@vger.kernel.org>
Fixes: 05f2d2f83b5a ("arm64: tlbflush: Introduce __flush_tlb_kernel_pgtable")
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/tlbflush.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -251,6 +251,7 @@ static inline void __flush_tlb_kernel_pg
 	dsb(ishst);
 	__tlbi(vaae1is, addr);
 	dsb(ish);
+	isb();
 }
 #endif
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D63AA61
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbfFIQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732093AbfFIQwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A63C206DF;
        Sun,  9 Jun 2019 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099123;
        bh=y4+aDopGjka30hHWzYoyHj/uq25HZ4xrzBfOKXhakAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jcw9JmRp++lVlSYSot0gHMVyV5zlfFmjX0BZMnOnCjH54yJVOxXYAywHHPALYSL3B
         pNtzEoFKZJi8WxVCPEsq5htHO6LKTVZzrN+FeU3aXdiYdeInwSvQwApAm5oEoe506p
         fH2S4VQo2xTKCekt2uOZyRSLKNUzDuTLt246ldDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meelis Roos <mroos@linux.ee>,
        James Clarke <jrtc27@jrtc27.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 18/83] sparc64: Fix regression in non-hypervisor TLB flush xcall
Date:   Sun,  9 Jun 2019 18:41:48 +0200
Message-Id: <20190609164129.051944596@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clarke <jrtc27@jrtc27.com>

commit d3c976c14ad8af421134c428b0a89ff8dd3bd8f8 upstream.

Previously, %g2 would end up with the value PAGE_SIZE, but after the
commit mentioned below it ends up with the value 1 due to being reused
for a different purpose. We need it to be PAGE_SIZE as we use it to step
through pages in our demap loop, otherwise we set different flags in the
low 12 bits of the address written to, thereby doing things other than a
nucleus page flush.

Fixes: a74ad5e660a9 ("sparc64: Handle extremely large kernel TLB range flushes more gracefully.")
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: James Clarke <jrtc27@jrtc27.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/mm/ultra.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -586,7 +586,7 @@ xcall_flush_tlb_kernel_range:	/* 44 insn
 	sub		%g7, %g1, %g3
 	srlx		%g3, 18, %g2
 	brnz,pn		%g2, 2f
-	 add		%g2, 1, %g2
+	 sethi		%hi(PAGE_SIZE), %g2
 	sub		%g3, %g2, %g3
 	or		%g1, 0x20, %g1		! Nucleus
 1:	stxa		%g0, [%g1 + %g3] ASI_DMMU_DEMAP
@@ -750,7 +750,7 @@ __cheetah_xcall_flush_tlb_kernel_range:
 	sub		%g7, %g1, %g3
 	srlx		%g3, 18, %g2
 	brnz,pn		%g2, 2f
-	 add		%g2, 1, %g2
+	 sethi		%hi(PAGE_SIZE), %g2
 	sub		%g3, %g2, %g3
 	or		%g1, 0x20, %g1		! Nucleus
 1:	stxa		%g0, [%g1 + %g3] ASI_DMMU_DEMAP



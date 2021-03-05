Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D9C32EB0E
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhCEMlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhCEMlW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:41:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 779D36502E;
        Fri,  5 Mar 2021 12:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948082;
        bh=UWLIWfYD+prOzt22pde3LwfE441zn2YNFpURl7hefXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x50rXlHjLozYN8VuJGc4Q/0EnpmGdBM914ZSUVFs3Xg5+9V0RJodjKk2i6VGVDiJE
         LOZk+1b0L7hosfMdS40TyAYtxKZinXOQnKdRS3AIb8IUi8t4RQF1QVUNjYg0eMNvvq
         BsEyv96RKUPoDQoSgiUeO4nUhVr/UX+xw5fqngaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 14/41] arm64: Remove redundant mov from LL/SC cmpxchg
Date:   Fri,  5 Mar 2021 13:22:21 +0100
Message-Id: <20210305120851.988419372@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
References: <20210305120851.255002428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 8df728e1ae614f592961e51f65d3e3212ede5a75 upstream.

The cmpxchg implementation introduced by commit c342f78217e8 ("arm64:
cmpxchg: patch in lse instructions when supported by the CPU") performs
an apparently redundant register move of [old] to [oldval] in the
success case - it always uses the same register width as [oldval] was
originally loaded with, and is only executed when [old] and [oldval] are
known to be equal anyway.

The only effect it seemingly does have is to take up a surprising amount
of space in the kernel text, as removing it reveals:

   text	   data	    bss	    dec	    hex	filename
12426658	1348614	4499749	18275021	116dacd	vmlinux.o.new
12429238	1348614	4499749	18277601	116e4e1	vmlinux.o.old

Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -264,7 +264,6 @@ __LL_SC_PREFIX(__cmpxchg_case_##name(vol
 	"	st" #rel "xr" #sz "\t%w[tmp], %" #w "[new], %[v]\n"	\
 	"	cbnz	%w[tmp], 1b\n"					\
 	"	" #mb "\n"						\
-	"	mov	%" #w "[oldval], %" #w "[old]\n"		\
 	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
 	  [v] "+Q" (*(unsigned long *)ptr)				\



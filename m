Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF8417FBA6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731786AbgCJNN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbgCJNN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AACC20409;
        Tue, 10 Mar 2020 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846035;
        bh=EpB+hNHyM4aBcJsJprlm1tfQc8ejGExjREpw2qKL+j4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxakJw3zlF92wyxCZxybkR3yYYGzrEC4lAa/0Y6Jaza07kPSwSgcyQxw4TIZ9GRk1
         3y5hP+gRGox5T2KDEiMIWoy/ndhDkMwkjHsfmg0cG6LpkzSRl8TCkDibw0v38+tvZq
         zAYlc/FuxMLnFQlMAKnbApaj0jo7Xyh3h4nIbSQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H.J. Lu" <hjl.tools@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 26/86] x86/boot/compressed: Dont declare __force_order in kaslr_64.c
Date:   Tue, 10 Mar 2020 13:44:50 +0100
Message-Id: <20200310124532.195024429@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H.J. Lu <hjl.tools@gmail.com>

[ Upstream commit df6d4f9db79c1a5d6f48b59db35ccd1e9ff9adfc ]

GCC 10 changed the default to -fno-common, which leads to

    LD      arch/x86/boot/compressed/vmlinux
  ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order'; \
    arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
  make[2]: *** [arch/x86/boot/compressed/Makefile:119: arch/x86/boot/compressed/vmlinux] Error 1

Since __force_order is already provided in pgtable_64.c, there is no
need to declare __force_order in kaslr_64.c.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200124181811.4780-1-hjl.tools@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/kaslr_64.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr_64.c b/arch/x86/boot/compressed/kaslr_64.c
index 748456c365f46..9557c5a15b91e 100644
--- a/arch/x86/boot/compressed/kaslr_64.c
+++ b/arch/x86/boot/compressed/kaslr_64.c
@@ -29,9 +29,6 @@
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
 #include "../../mm/ident_map.c"
 
-/* Used by pgtable.h asm code to force instruction serialization. */
-unsigned long __force_order;
-
 /* Used to track our page table allocation area. */
 struct alloc_pgt_data {
 	unsigned char *pgt_buf;
-- 
2.20.1




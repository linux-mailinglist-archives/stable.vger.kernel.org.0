Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C781C35BFDF
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhDLJHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240300AbhDLJFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19A206137A;
        Mon, 12 Apr 2021 09:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218167;
        bh=AZMnZGPaazAcPmQLR49HuHQaiEx3+k4/4sAdu+lEBYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kld9jBUOg5KaiyGwz58e15xRRcciJnxTgaJ1wkMyBBFXx0U7f+zK6TTSUKeKFGZcM
         deO5Fen14892gy79uuia9hNOL+NjMuWk44L/JSi0pM65MyTXVrLzEG9R60X66W2ibO
         9vhH424piX/oiJGF2Tc1jfGWA3hlE1jpTSixPHE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.11 089/210] powerpc/vdso: Make sure vdso_wrapper.o is rebuilt everytime vdso.so is rebuilt
Date:   Mon, 12 Apr 2021 10:39:54 +0200
Message-Id: <20210412084018.976737408@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 791f9e36599d94af5a76d3f74d04e16326761aae upstream.

Commit bce74491c300 ("powerpc/vdso: fix unnecessary rebuilds of
vgettimeofday.o") moved vdso32_wrapper.o and vdso64_wrapper.o out
of arch/powerpc/kernel/vdso[32/64]/ and removed the dependencies in
the Makefile. This leads to the wrappers not being re-build hence the
kernel embedding the old vdso library.

Add back missing dependencies to ensure vdso32_wrapper.o and vdso64_wrapper.o
are rebuilt when vdso32.so.dbg and vdso64.so.dbg are changed.

Fixes: bce74491c300 ("powerpc/vdso: fix unnecessary rebuilds of vgettimeofday.o")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8bb015bc98c51d8ced581415b7e3d157e18da7c9.1617181918.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -191,3 +191,7 @@ $(obj)/prom_init_check: $(src)/prom_init
 targets += prom_init_check
 
 clean-files := vmlinux.lds
+
+# Force dependency (incbin is bad)
+$(obj)/vdso32_wrapper.o : $(obj)/vdso32/vdso32.so.dbg
+$(obj)/vdso64_wrapper.o : $(obj)/vdso64/vdso64.so.dbg



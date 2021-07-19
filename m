Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88C03CE5FF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350474AbhGSP7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349676AbhGSPuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C19C6191F;
        Mon, 19 Jul 2021 16:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712142;
        bh=OwA5QZYq2jFhyFahTJ1Ej3yiVjxkMNWVrLHImZjzpBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soeUEAZT14e1GXwFIWTGhOKenmhfgPcmItb8VQXhzKyudYmycRSyxmA9H0W3YXB87
         s58qjKem2iFyUGizhwJtzsVIvqfbJe2I9bOLBVvOoYqcryOirwc/bYK+wKmN1vfuAD
         U6S9wIo9P2rtH3zEWfzzN9g0JipEXeyw4WIIrE00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brian Cain <bcain@codeaurora.org>,
        David Rientjes <rientjes@google.com>,
        Oliver Glitta <glittao@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 223/292] hexagon: use common DISCARDS macro
Date:   Mon, 19 Jul 2021 16:54:45 +0200
Message-Id: <20210719144950.303702496@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 681ba73c72302214686401e707e2087ed11a6556 ]

ld.lld warns that the '.modinfo' section is not currently handled:

ld.lld: warning: kernel/built-in.a(workqueue.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(printk/printk.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(irq/spurious.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(rcu/update.o):(.modinfo) is being placed in '.modinfo'

The '.modinfo' section was added in commit 898490c010b5 ("moduleparam:
Save information about built-in modules in separate file") to the DISCARDS
macro but Hexagon has never used that macro.  The unification of DISCARDS
happened in commit 023bf6f1b8bf ("linker script: unify usage of discard
definition") in 2009, prior to Hexagon being added in 2011.

Switch Hexagon over to the DISCARDS macro so that anything that is
expected to be discarded gets discarded.

Link: https://lkml.kernel.org/r/20210521011239.1332345-3-nathan@kernel.org
Fixes: e95bf452a9e2 ("Hexagon: Add configuration and makefiles for the Hexagon architecture.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/vmlinux.lds.S | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/hexagon/kernel/vmlinux.lds.S b/arch/hexagon/kernel/vmlinux.lds.S
index 20f19539c5fc..57465bff1fe4 100644
--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -61,14 +61,9 @@ SECTIONS
 
 	_end = .;
 
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		EXIT_CALL
-	}
-
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
 
+	DISCARDS
 }
-- 
2.30.2




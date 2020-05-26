Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16861E2C78
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404187AbgEZTPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404196AbgEZTPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30ABD208B3;
        Tue, 26 May 2020 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520510;
        bh=zcyVS/NHVYgcarFW3W2ZpzEq8bYzC9EzovUz+I2DAyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSZIA+gafZ33oeMDnYNIekdQHiYkWZG/SE0R7XCNo3GlJ/QDi/iA4nPtDekMB+9Is
         qyyn78euZ7YRNsAppnPncBtHYvTs4H0ky3SKiklh163mg5bGE9GnlRyo/MYY1Zxz+l
         NigwDByTjIokYRv+7V30awp/DLnjCe4zfUU300Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 071/126] powerpc/64s: Disable STRICT_KERNEL_RWX
Date:   Tue, 26 May 2020 20:53:28 +0200
Message-Id: <20200526183944.154484688@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8659a0e0efdd975c73355dbc033f79ba3b31e82c upstream.

Several strange crashes have been eventually traced back to
STRICT_KERNEL_RWX and its interaction with code patching.

Various paths in our ftrace, kprobes and other patching code need to
be hardened against patching failures, otherwise we can end up running
with partially/incorrectly patched ftrace paths, kprobes or jump
labels, which can then cause strange crashes.

Although fixes for those are in development, they're not -rc material.

There also seem to be problems with the underlying strict RWX logic,
which needs further debugging.

So for now disable STRICT_KERNEL_RWX on 64-bit to prevent people from
enabling the option and tripping over the bugs.

Fixes: 1e0fc9d1eb2b ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX for some configs")
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200520133605.972649-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,7 +129,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC32 && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64



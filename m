Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801D5344222
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhCVMit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhCVMhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7AA619A1;
        Mon, 22 Mar 2021 12:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416618;
        bh=UFD/eA+YxSgr0TsrY7PYKVpcbMXcz9ewaIdpfZb7PR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDAeBN6EvW8HaMOVWo0C7Vxz8knW4hCccAVltxLVi8+HbQUHl9W4sUoDxyDDdKV3X
         xKxW2D0kv1oUFfp8mqJhWwCrtvmIm2Hf6jYf0nK+6cqOz6FADC4TIZ947Nw2W0o5GP
         cLGtPCx9CMyuO7Mkew2dZQvIjXRq5XLxGnRKdsBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 055/157] riscv: Correct SPARSEMEM configuration
Date:   Mon, 22 Mar 2021 13:26:52 +0100
Message-Id: <20210322121935.499402986@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit a5406a7ff56e63376c210b06072aa0ef23473366 upstream.

There are two issues for RV32,
1) if use FLATMEM, it is useless to enable SPARSEMEM_STATIC.
2) if use SPARSMEM, both SPARSEMEM_VMEMMAP and SPARSEMEM_STATIC is enabled.

Fixes: d95f1a542c3d ("RISC-V: Implement sparsemem")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -84,7 +84,6 @@ config RISCV
 	select PCI_MSI if PCI
 	select RISCV_INTC
 	select RISCV_TIMER if RISCV_SBI
-	select SPARSEMEM_STATIC if 32BIT
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
@@ -145,7 +144,8 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on MMU
-	select SPARSEMEM_VMEMMAP_ENABLE
+	select SPARSEMEM_STATIC if 32BIT && SPARSMEM
+	select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE



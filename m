Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA77344161
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCVMdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231462AbhCVMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125DC6199F;
        Mon, 22 Mar 2021 12:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416327;
        bh=siGEuMR7e6EFUCbTIBIWlr5pETZWu4iXpAaxpKKLTrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBknAiYWv4YjDivPELNLrHoZgKyqehGClWVK0fPxquSrFb2a4pY2MZ7UhrhTsb0vc
         hOEJx9WrOnzXxReuBF1bPerI58s5fTYFQoI/k/8QE/OCAVezoqwCbqd0dIbldukYZT
         0b4MsbvkLzhEaRjBRFr2IRL6Bq+8Wfj1tsVGE/5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.11 063/120] riscv: Correct SPARSEMEM configuration
Date:   Mon, 22 Mar 2021 13:27:26 +0100
Message-Id: <20210322121931.789152049@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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
@@ -87,7 +87,6 @@ config RISCV
 	select PCI_MSI if PCI
 	select RISCV_INTC
 	select RISCV_TIMER if RISCV_SBI
-	select SPARSEMEM_STATIC if 32BIT
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
@@ -148,7 +147,8 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on MMU
-	select SPARSEMEM_VMEMMAP_ENABLE
+	select SPARSEMEM_STATIC if 32BIT && SPARSMEM
+	select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3F344352
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhCVMtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232683AbhCVMr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59442619DF;
        Mon, 22 Mar 2021 12:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417036;
        bh=HlC3nQXPKVbRKjrW/7j773KcMLB1/X+Uv1hUXrjv6jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMiWFkikW5n1vVnjX5DpcHNupA4UXZKIWwfFuWSu6H4KpQWvlp3cYbItOQns3HuZa
         0owRVxAaz99Kp/82UGk7rY5B10qldvv14b7gF+DKupdfkjkxj+fbhmNMADDba+YJk/
         tqcbJfH4wuoW8FzmCbWfwLx6MXfUFqlmbKMa3hzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.4 29/60] riscv: Correct SPARSEMEM configuration
Date:   Mon, 22 Mar 2021 13:28:17 +0100
Message-Id: <20210322121923.347547133@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
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
@@ -58,7 +58,6 @@ config RISCV
 	select EDAC_SUPPORT
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
-	select SPARSEMEM_STATIC if 32BIT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_COPY_THREAD_TLS
@@ -102,7 +101,8 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on MMU
-	select SPARSEMEM_VMEMMAP_ENABLE
+	select SPARSEMEM_STATIC if 32BIT && SPARSMEM
+	select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool ARCH_SPARSEMEM_ENABLE



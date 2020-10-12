Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B42528B8C0
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389976AbgJLNzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389685AbgJLNpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1698322266;
        Mon, 12 Oct 2020 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510271;
        bh=Cq25miAfdQyRlTPU8qtyp+GbvM4dFtyLo9Qe4f8Imhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e30ICbWnvDDDYWk0HoIZZ4AMHOuxn+d2jxKPXqI+NjitdJ/4TKVwg5MbogfOKjsNv
         3QrKy72ZnwxK+K5U1BXOzEOduSi0grBMatnLYz0AWK6OwamqAOEby7uSOzImf2rgbD
         gfjZjTAwTfcE1eYQlmAoEN5/cRb9qhZfsJKeinZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.8 028/124] RISC-V: Make sure memblock reserves the memory containing DT
Date:   Mon, 12 Oct 2020 15:30:32 +0200
Message-Id: <20201012133148.208719220@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

commit a78c6f5956a949b496a5b087188dde52483edf51 upstream.

Currently, the memory containing DT is not reserved. Thus, that region
of memory can be reallocated or reused for other purposes. This may result
in  corrupted DT for nommu virt board in Qemu. We may not face any issue
in kendryte as DT is embedded in the kernel image for that.

Fixes: 6bd33e1ece52 ("riscv: add nommu support")
Cc: stable@vger.kernel.org
Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -515,6 +515,7 @@ asmlinkage void __init setup_vm(uintptr_
 #else
 	dtb_early_va = (void *)dtb_pa;
 #endif
+	dtb_early_pa = dtb_pa;
 }
 
 static inline void setup_vm_final(void)



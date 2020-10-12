Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9355528B7F4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgJLNsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389761AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC76B22370;
        Mon, 12 Oct 2020 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510329;
        bh=4fRAaOVTv/qlBcCTxLcq0CDp/BUdDur046Ay1mTLBCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkqkmWvNDSUdhNy8rRo8+/9D+qp6+3XmrDZS53SPHiRQjvZ7n3f0+yuaQtziK4pWo
         twqHLQtgAZ6+xLnwcqab1Bte2KvZTKWWroBAmOWddH0ngbtmTovjJAkygZw++d7KXe
         xt2Myczhui1YRbsaEqZKRyv1Tm6fTtGVVHiEuRms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.8 022/124] bpf: Prevent .BTF section elimination
Date:   Mon, 12 Oct 2020 15:30:26 +0200
Message-Id: <20201012133147.919333925@linuxfoundation.org>
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

From: Tony Ambardar <tony.ambardar@gmail.com>

commit 65c204398928f9c79f1a29912b410439f7052635 upstream.

Systems with memory or disk constraints often reduce the kernel footprint
by configuring LD_DEAD_CODE_DATA_ELIMINATION. However, this can result in
removal of any BTF information.

Use the KEEP() macro to preserve the BTF data as done with other important
sections, while still allowing for smaller kernels.

Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/a635b5d3e2da044e7b51ec1315e8910fbce0083f.1600417359.git.Tony.Ambardar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -641,7 +641,7 @@
 #define BTF								\
 	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
 		__start_BTF = .;					\
-		*(.BTF)							\
+		KEEP(*(.BTF))						\
 		__stop_BTF = .;						\
 	}
 #else



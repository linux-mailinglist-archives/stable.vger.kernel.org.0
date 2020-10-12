Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE528B7A4
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbgJLNpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731329AbgJLNmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:42:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B720722228;
        Mon, 12 Oct 2020 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510120;
        bh=UJHkcwtAMBTTaQj49a9rbFF+vKgSWPKHudMnhOaOilU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PF78RTHanPxwp0cH3g3nX0neB7/4SQM0+Z4rEg9A9ViVQqQLB32o0BYKoaCbdwc0c
         ZK6SB+AmWQzQW6GohRd+E20aQkGwQFQMQmsxJHYwX7WIk+jebsOeqdKG8vHkxKH4Zl
         FDD0WTlVDxxgxXvQeuMnlth7J1gjDkhHA19ZOQrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Ambardar <Tony.Ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.4 18/85] bpf: Prevent .BTF section elimination
Date:   Mon, 12 Oct 2020 15:26:41 +0200
Message-Id: <20201012132633.725047120@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
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
@@ -599,7 +599,7 @@
 #define BTF								\
 	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
 		__start_BTF = .;					\
-		*(.BTF)							\
+		KEEP(*(.BTF))						\
 		__stop_BTF = .;						\
 	}
 #else



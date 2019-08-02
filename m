Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD297F4A1
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391121AbfHBJb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389953AbfHBJb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9575217D6;
        Fri,  2 Aug 2019 09:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738318;
        bh=OMHrDYVAbNSmSp3IrYaUXbgj1wrmIhORmLYKL5/x5Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIWvUmCRwoANbhbY1xaXviPGgl9wrSIUCKJerm7EAoSYQRomQe30MvnKj3xbK29Sb
         IuoVYbEm0wZxL3JRIjqWHj97pFDy3oOKhs9ZH42nF88XT5qYg0IKIDySSm1g0C2EWe
         ITGqQ49Eg5lERxLQunEdqH0eFBK0XuMKQRBf60aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 030/158] bpf: silence warning messages in core
Date:   Fri,  2 Aug 2019 11:27:31 +0200
Message-Id: <20190802092209.836052080@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aee450cbe482a8c2f6fa5b05b178ef8b8ff107ca ]

Compiling kernel/bpf/core.c with W=1 causes a flood of warnings:

kernel/bpf/core.c:1198:65: warning: initialized field overwritten [-Woverride-init]
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~
kernel/bpf/core.c:1198:65: note: (near initialization for 'public_insntable[12]')
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~

98 copies of the above.

The attached patch silences the warnings, because we *know* we're overwriting
the default initializer. That leaves bpf/core.c with only 6 other warnings,
which become more visible in comparison.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 13272582eee0..677991f29d66 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,4 +1,5 @@
 obj-y := core.o
+CFLAGS_core.o += $(call cc-disable-warning, override-init)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o
-- 
2.20.1




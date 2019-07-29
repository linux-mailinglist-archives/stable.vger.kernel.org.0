Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D33479981
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfG2TZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729723AbfG2TZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:25:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34EEA2070B;
        Mon, 29 Jul 2019 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428354;
        bh=EkawAHA1gMRyZBd2/hM+E1AMtSzztW8Lj/Lsyik5nqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjILzCtToYD144EcO6VWYePeOpgdyqFxXUhwW2cDXYgrMKyjsuNEMtJsGxaH777Nn
         K8KC9Lg4cBFD6VkRua8hK7SpFnTCJeYb+Yc0tGP7/Mgl8zxZGD+D9LI4rxwBS1rLGN
         +BBRBFRSGrdlJpKPyX5S4A0eNzxG7JEyyGJF+c1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/293] bpf: silence warning messages in core
Date:   Mon, 29 Jul 2019 21:18:59 +0200
Message-Id: <20190729190826.966000573@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index af3ab6164ff5..be282c135a66 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y := core.o
+CFLAGS_core.o += $(call cc-disable-warning, override-init)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
-- 
2.20.1




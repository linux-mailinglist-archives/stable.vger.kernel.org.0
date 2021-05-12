Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D52237CD9C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbhELQ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244019AbhELQm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698A461C65;
        Wed, 12 May 2021 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835763;
        bh=AWKiF1baAFwWPihOl3NT3WpHQ05I8vK6TUH2m0pRA1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7sPOxrunlQBz9y5YOXNr4Ay9NxuAC4M52i7k0ZYEPT1nkgHAjtyK1zgiNpRx6zjS
         5jSC57sQGREZjZ3xlfAOzCp3qK2jHgyWLKxT4knc3xMEgFV9Id+iUNhd1UQK9bZPqR
         jXaMfHcB4KO2wlxFSjl2RSy4ptPXwHj5tOMfpWuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 475/677] MIPS/bpf: Enable bpf_probe_read{, str}() on MIPS again
Date:   Wed, 12 May 2021 16:48:41 +0200
Message-Id: <20210512144853.135234406@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 66633abd0642f1e89d26e15f36fb13d3a1c535ff ]

After commit 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to
archs where they work"), bpf_probe_read{, str}() functions were no longer
available on MIPS, so there exist some errors when running bpf program:

root@linux:/home/loongson/bcc# python examples/tracing/task_switch.py
bpf: Failed to load program: Invalid argument
[...]
11: (85) call bpf_probe_read#4
unknown func bpf_probe_read#4
[...]
Exception: Failed to load BPF program count_sched: Invalid argument

ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE should be restricted to archs
with non-overlapping address ranges, but they can overlap in EVA mode
on MIPS, so select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE if !EVA in
arch/mips/Kconfig, otherwise the bpf old helper bpf_probe_read() will
not be available.

This is similar with the commit d195b1d1d119 ("powerpc/bpf: Enable
bpf_probe_read{, str}() on powerpc again").

Fixes: 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d89efba3d8a4..e89d63cd92d1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -6,6 +6,7 @@ config MIPS
 	select ARCH_BINFMT_ELF_STATE if MIPS_FP_SUPPORT
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_KCOV
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE if !EVA
 	select ARCH_HAS_PTE_SPECIAL if !(32BIT && CPU_HAS_RIXI)
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-- 
2.30.2




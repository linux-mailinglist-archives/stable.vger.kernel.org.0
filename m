Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2B3D628F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhGZPgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhGZPfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3F86604AC;
        Mon, 26 Jul 2021 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316180;
        bh=84u/XjAnu2b9gXNw6fBDvyiuCJA9UbdN0DmegULQy6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaMa2wrH1ogjLj0cKwGELpvAawr2Zej/wge+VJl2OeXY3mV2L6cTZFXGjNwuq9DUC
         E1qX+f+kHfOl621vAdEjujM47Pa8WbM1qvadsMMM09umOiXQU9dZGPMZzGb4iDlRhd
         SQW/ZY7C6FX2NSNzLRLRpzvjwxbCMWjsSGmrr+yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.13 219/223] arm64: entry: fix KCOV suppression
Date:   Mon, 26 Jul 2021 17:40:11 +0200
Message-Id: <20210726153853.344320397@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit e6f85cbeb23bd74b8966cf1f15bf7d01399ff625 upstream.

We suppress KCOV for entry.o rather than entry-common.o. As entry.o is
built from entry.S, this is pointless, and permits instrumentation of
entry-common.o, which is built from entry-common.c.

Fix the Makefile to suppress KCOV for entry-common.o, as we had intended
to begin with. I've verified with objdump that this is working as
expected.

Fixes: bf6fa2c0dda7 ("arm64: entry: don't instrument entry code with KCOV")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210715123049.9990-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -17,7 +17,7 @@ CFLAGS_syscall.o	+= -fno-stack-protector
 # It's not safe to invoke KCOV when portions of the kernel environment aren't
 # available or are out-of-sync with HW state. Since `noinstr` doesn't always
 # inhibit KCOV instrumentation, disable it for the entire compilation unit.
-KCOV_INSTRUMENT_entry.o := n
+KCOV_INSTRUMENT_entry-common.o := n
 
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\



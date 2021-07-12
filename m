Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614E43C5212
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349764AbhGLHom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:44:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347567AbhGLHju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4616613D2;
        Mon, 12 Jul 2021 07:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075300;
        bh=YeSgRczbmbSxo4Z5IzaKSbrJnSZG/xkyc9myQMoVzPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bylC2TjkNONM98IWkgfQfmd+F82BwVzCivwgrSqBiPagfojEoj7JhNDLrg0/oJSHs
         XJJEcdCfd+vAd8Ur+8iVY3VzHNzu54+YC0ebvPZoK9O8dmqaRYZtH/CNMqHJGu63bR
         TKw2B53N84oz50hHTGIUzmRl2GfAglyU1asxuoGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 173/800] arm64: entry: dont instrument entry code with KCOV
Date:   Mon, 12 Jul 2021 08:03:16 +0200
Message-Id: <20210712060937.277626458@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit bf6fa2c0dda751863c3446aa64d733013bec4a19 ]

The code in entry-common.c runs at exception entry and return
boundaries, where portions of the kernel environment aren't available.
For example, RCU may not be watching, and lockdep state may be
out-of-sync with the hardware. Due to this, it is not sound to
instrument this code.

We generally avoid instrumentation by marking the entry functions as
`noinstr`, but currently this doesn't inhibit KCOV instrumentation.
Prevent this by disabling KCOV for the entire compilation unit.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210607094624.34689-20-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 6cc97730790e..787c3c83edd7 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -14,6 +14,11 @@ CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_syscall.o	 = -fstack-protector -fstack-protector-strong
 CFLAGS_syscall.o	+= -fno-stack-protector
 
+# It's not safe to invoke KCOV when portions of the kernel environment aren't
+# available or are out-of-sync with HW state. Since `noinstr` doesn't always
+# inhibit KCOV instrumentation, disable it for the entire compilation unit.
+KCOV_INSTRUMENT_entry.o := n
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
-- 
2.30.2




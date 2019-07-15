Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F6468F1C
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbfGOOMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbfGOOMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:12:13 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD57206B8;
        Mon, 15 Jul 2019 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199933;
        bh=Kt7BcCS8y0HPbDKyGiyQBD+74w3LqOFCaaM41qDhzp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hL97L2DvQPfKhA1XhvAt2igkgrvZ/MczH0C40q3XtW+VkZ88uJRcyK9UiKQg4M3I
         qj9m3PCiT37vZcFQiUHT+DxRtQhfYl/NfGSgNc4HBB9mUeqix4Oc7E6bGQ/VxqcJOH
         tsB5NvpBzrHZ1+577zKpdAmy22uvNck6EI1hpkGY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 141/219] x86/build: Add 'set -e' to mkcapflags.sh to delete broken capflags.c
Date:   Mon, 15 Jul 2019 10:02:22 -0400
Message-Id: <20190715140341.6443-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit bc53d3d777f81385c1bb08b07bd1c06450ecc2c1 ]

Without 'set -e', shell scripts continue running even after any
error occurs. The missed 'set -e' is a typical bug in shell scripting.

For example, when a disk space shortage occurs while this script is
running, it actually ends up with generating a truncated capflags.c.

Yet, mkcapflags.sh continues running and exits with 0. So, the build
system assumes it has succeeded.

It will not be re-generated in the next invocation of Make since its
timestamp is newer than that of any of the source files.

Add 'set -e' so that any error in this script is caught and propagated
to the build system.

Since 9c2af1c7377a ("kbuild: add .DELETE_ON_ERROR special target"),
make automatically deletes the target on any failure. So, the broken
capflags.c will be deleted automatically.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: https://lkml.kernel.org/r/20190625072622.17679-1-yamada.masahiro@socionext.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mkcapflags.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapflags.sh
index d0dfb892c72f..aed45b8895d5 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -4,6 +4,8 @@
 # Generate the x86_cap/bug_flags[] arrays from include/asm/cpufeatures.h
 #
 
+set -e
+
 IN=$1
 OUT=$2
 
-- 
2.20.1


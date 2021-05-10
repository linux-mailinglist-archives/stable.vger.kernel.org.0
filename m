Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B567378F00
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhEJN1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243937AbhEJL5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40CF760FE4;
        Mon, 10 May 2021 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620647801;
        bh=ntF6ZVYYbcXM4UJ6U6+wFH2fXLxfV8Yn/5JKdRYUlEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFj/tiy8WuRI/MEx+QUTdew9LS1xq/HwlVljaTcWX63d/Nm18qZ8/5h06ymWZ0c7U
         BpXZ2douytxTSbvzKMsl1OReHfT+Vp15p70d6Vr1rH8GRFS8QyyEJ6br1+QkGgglxO
         UcPivMLu45nVnKPixUk8YvKp1aPpLkd7mcHHrvf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 085/384] kselftest/arm64: mte: Fix compilation with native compiler
Date:   Mon, 10 May 2021 12:17:54 +0200
Message-Id: <20210510102017.691391663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 4a423645bc2690376a7a94b4bb7b2f74bc6206ff ]

The mte selftest Makefile contains a check for GCC, to add the memtag
-march flag to the compiler options. This check fails if the compiler
is not explicitly specified, so reverts to the standard "cc", in which
case --version doesn't mention the "gcc" string we match against:
$ cc --version | head -n 1
cc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0

This will not add the -march switch to the command line, so compilation
fails:
mte_helper.S: Assembler messages:
mte_helper.S:25: Error: selected processor does not support `irg x0,x0,xzr'
mte_helper.S:38: Error: selected processor does not support `gmi x1,x0,xzr'
...

Actually clang accepts the same -march option as well, so we can just
drop this check and add this unconditionally to the command line, to avoid
any future issues with this check altogether (gcc actually prints
basename(argv[0]) when called with --version).

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Mark Brown <broone@kernel.org>
Link: https://lore.kernel.org/r/20210319165334.29213-2-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/Makefile b/tools/testing/selftests/arm64/mte/Makefile
index 0b3af552632a..df15d44aeb8d 100644
--- a/tools/testing/selftests/arm64/mte/Makefile
+++ b/tools/testing/selftests/arm64/mte/Makefile
@@ -6,9 +6,7 @@ SRCS := $(filter-out mte_common_util.c,$(wildcard *.c))
 PROGS := $(patsubst %.c,%,$(SRCS))
 
 #Add mte compiler option
-ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep gcc),)
 CFLAGS += -march=armv8.5-a+memtag
-endif
 
 #check if the compiler works well
 mte_cc_support := $(shell if ($(CC) $(CFLAGS) -E -x c /dev/null -o /dev/null 2>&1) then echo "1"; fi)
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231441FE2B0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbgFRCD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:03:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730978AbgFRBX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870DD20776;
        Thu, 18 Jun 2020 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443407;
        bh=xNVreF+mgMDEyo0YZIP2ESdFi3mlsEMhDpczxsWs2n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IwukQqUa3BdHxmHlWMDNGqUiXj7QK8SdAtq7GYMAHhvShe6sr5EIaMFKatAPstEQK
         MB5UyzhgnAlfziIi2s6lbI90Rk3Liue2zFEgq5xQ9JeY+kkcxasGN5dh0FXBgCBWd3
         v26DGIKv6jmZ2fKvfAl6hH1W8Qtk9jS/lLV7S3n0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 051/172] x86/purgatory: Disable various profiling and sanitizing options
Date:   Wed, 17 Jun 2020 21:20:17 -0400
Message-Id: <20200618012218.607130-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e2ac07c06058ae2d58b45bbf2a2a352771d76fcb ]

Since the purgatory is a special stand-alone binary, various profiling
and sanitizing options must be disabled. Having these options enabled
typically will cause dependencies on various special symbols exported by
special libs / stubs used by these frameworks. Since the purgatory is
special, it is not linked against these stubs causing missing symbols in
the purgatory if these options are not disabled.

Sync the set of disabled profiling and sanitizing options with that from
drivers/firmware/efi/libstub/Makefile, adding
-DDISABLE_BRANCH_PROFILING to the CFLAGS and setting:

  GCOV_PROFILE                    := n
  UBSAN_SANITIZE                  := n

This fixes broken references to ftrace_likely_update() when
CONFIG_TRACE_BRANCH_PROFILING is enabled and to __gcov_init() and
__gcov_exit() when CONFIG_GCOV_KERNEL is enabled.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200317130841.290418-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/purgatory/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index b81b5172cf99..2cfa0caef133 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -15,7 +15,10 @@ $(obj)/sha256.o: $(srctree)/lib/sha256.c FORCE
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
 targets += purgatory.ro
 
+# Sanitizer, etc. runtimes are unavailable and cannot be linked here.
+GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT := n
 
 # These are adjustments to the compiler flags used for objects that
@@ -23,7 +26,7 @@ KCOV_INSTRUMENT := n
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
 PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss
-PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN)
+PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN) -DDISABLE_BRANCH_PROFILING
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
2.25.1


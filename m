Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727F9205CC9
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgFWUF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387753AbgFWUF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:05:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF745206C3;
        Tue, 23 Jun 2020 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942726;
        bh=4bFTiyTI+21Z9p8NR5i0JtG0TLkhfG+w1D0qOnIinuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJC/gF+pYWi42ECdcSJsFVgw+SF2XzRU4hhxa14fzlQURBNqF1+Lw7wRbrX+uwi86
         rT3FmtJTkzEH64loukh/klaZCr+/8HGbSkPFMEwYWJ8nxTN9MMieoNnDsgCuvZ6Ly+
         kjra/HURrZX6b92++NFFdAWkpxsEtDPbwlExjve4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 112/477] x86/purgatory: Disable various profiling and sanitizing options
Date:   Tue, 23 Jun 2020 21:51:49 +0200
Message-Id: <20200623195412.887062030@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fb4ee54443799..9733d1cc791dd 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -17,7 +17,10 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
 targets += purgatory.ro
 
+# Sanitizer, etc. runtimes are unavailable and cannot be linked here.
+GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
+UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT := n
 
 # These are adjustments to the compiler flags used for objects that
@@ -25,7 +28,7 @@ KCOV_INSTRUMENT := n
 
 PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
 PURGATORY_CFLAGS := -mcmodel=large -ffreestanding -fno-zero-initialized-in-bss
-PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN)
+PURGATORY_CFLAGS += $(DISABLE_STACKLEAK_PLUGIN) -DDISABLE_BRANCH_PROFILING
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-- 
2.25.1




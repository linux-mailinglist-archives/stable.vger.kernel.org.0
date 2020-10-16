Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E8290AFD
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 19:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733113AbgJPRxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 13:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733030AbgJPRxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 13:53:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F511C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 10:53:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e9so3180154ybj.11
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=q7DWLNuboaXQBizRCQAQyueFvatCQ/DSdeo5vJZMrAY=;
        b=rgKPCbJGLgft+BSGYv5zU9/B8Fy2RR+adQX6+Xf0skJuSDykgcLy8PP/FGtBkOdBVH
         AMijgr+kUt7Uh/XEvDxBd88PmIts4b//UJxphGkJZF1Ff9w+JakMuXNcWxSLmcVtB6pD
         h1cZB00Da89unxkxHrGSVGS3k7Tmd1IruIE5WBsvfYvzRX1Cx7pGVub+I1oLAB5nPt07
         PpAlbde98kNk23Fk9uikgX+xf9/rgGF7ohlQ0t4Tg2lSVlndiphVNJq326MpPER0xCQo
         zRb0fcxyqIgFTxXVplWLPJVFPGERwp2nHs6Nfg0pms8kJHw1PNN2ixfEvAuY4C3w0biJ
         8o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=q7DWLNuboaXQBizRCQAQyueFvatCQ/DSdeo5vJZMrAY=;
        b=hW87foQd1BB5XZzmQtC4NzbKg+Hs6jA/awnyQ+1+BSKNYr+hzNGzqmwFn0K4HVpZZy
         diipxHsInRkjECY0ZcnwZo1EYnFsdZTPAdSzHnEVSHblU+FbuSxaA5NNE+bxz+Oc/6Wz
         ogZs+iTGSYe/zs5ISbGe9pNzp+uS79PUv2X01Eo0KB/elmQ1m0a9RB8f4J+7d0gJWOU+
         4X+Szrucgb1JqPzeLtqDWR3qO4OMoYmke7rZk+J2/j/hQwP+VZcMAqWiIjZXWpLhHAop
         7439jBhsc2t5RygS5KJi2qPjqDRZwkSiBM4AkdjBpQMMTpvBO+ft7KLWj9eTxnlQ15pE
         bHQQ==
X-Gm-Message-State: AOAM530LjBi9hK7ttycLJMw9wVcTIMe0N2bikG5mnlKPf+PGNTIExi03
        y+vAZNB8LKnc1pWSo84U1QQSVDBIEZmuEUXirlQ=
X-Google-Smtp-Source: ABdhPJxSuVrQnN6q9GhwE9ZaMkTMGQu9k93WTjejDlDTW3Rfwy3zO1f9pPDT45mRIMg3cPkVRP6J9lEdwpAGYIN1t5Y=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a25:9009:: with SMTP id
 s9mr7105616ybl.471.1602870822453; Fri, 16 Oct 2020 10:53:42 -0700 (PDT)
Date:   Fri, 16 Oct 2020 10:53:39 -0700
Message-Id: <20201016175339.2429280-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        "=?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?=" <maskray@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
CONFIG_RELOCATABLE=n, we observe the following failure when trying to
link the kernel image with LD=ld.lld:

error: section: .exit.data is not contiguous with other relro sections

ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
was previously fixed, but only for CONFIG_RELOCATABLE=y.

Cc: stable@vger.kernel.org
Fixes: commit 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
While upgrading our toolchains for Android, we started seeing the above
failure for a particular config that enabled KASAN but disabled KASLR.
This was on a 5.4 stable branch.  It looks like
commit dd4bc6076587 ("arm64: warn on incorrect placement of the kernel by the bootloader")
made RELOCATABLE=y the default and depend on EXPERT=y. With those two
enabled, we can then reproduce the same failure on mainline.


 arch/arm64/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index f4717facf31e..674241df91ab 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,13 +10,13 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X
+LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
 
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
 # for relative relocs, since this leads to better Image compression
 # with the relocation offsets always being zero.
-LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext -z norelro \
+LDFLAGS_vmlinux		+= -shared -Bsymbolic -z notext \
 			$(call ld-option, --no-apply-dynamic-relocs)
 endif
 
-- 
2.29.0.rc1.297.gfa9743e501-goog


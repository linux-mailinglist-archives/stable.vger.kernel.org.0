Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15110342A5F
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 05:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhCTERD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 00:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTEQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 00:16:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776A9C061765
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:35 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so9263541pjb.0
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 21:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AnMg47T8Z7mVw2QYcNj+ca1PflwjFpQ0knP09yHBQe8=;
        b=PrfZRsmz3UsByLzMgIDUIzCr+LhjgOYA+Nh9/H13Agb9hHJi7ziHDjVe3JuOzAL2FX
         xUiC3V+PT+eCW5XYT+iDKAAQ0o3CxYXpEdi8GCRjDUw/U5Of+RBSi7tmM31+HWvwZ7Fm
         XIU5+XedKEFeMg9zmn1ExdTrB4wQMwqm98ODw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AnMg47T8Z7mVw2QYcNj+ca1PflwjFpQ0knP09yHBQe8=;
        b=sygoO9prkvjMenCDqM0tAWDaKl577GGDKIB/DN9G+lm87+nB3JDkbLWn4EIi6gAN42
         ocskthYBxPkwDL0H8x7fBjuw9LY59UWrjdmQaZs0cPUiDD/gFL07XEf/AnYULte0B/Lc
         aov8YqCDml03svPH4q+InQVVo2LxaFbbeXLp5zUGTpy7hGzDlpGQVG6JKI6LsD51QZ3i
         MBjUHkALLYOBpio7GKzm+MDrzVxlyVUOJDIfsbo6gXW/sVKMzw0AtOWJyIS0n3ZuZNdx
         i81p0aGjzvUfvnH4VQjuAsZHuDcb1t2X+UF7Oy+gM9D20vxAY1rSwALISfjvIivSmMRk
         N9oA==
X-Gm-Message-State: AOAM531+wYLmpPkp7EH458dE+geFxz2xdD4Pri5DZKRGQEGraseELnMA
        cQ/1QxT19o3FyF+qlgBZ+orY28ITq0MSVA==
X-Google-Smtp-Source: ABdhPJw4hRCPEH2/kfcgtaref9TF8lFo2zdT4xoTpYUa2F76wDEZKZFyP619enk9tKUj0PiS8O5eJg==
X-Received: by 2002:a17:90a:ab09:: with SMTP id m9mr1910002pjq.122.1616213794673;
        Fri, 19 Mar 2021 21:16:34 -0700 (PDT)
Received: from drinkcat2.tpe.corp.google.com ([2401:fa00:1:b:f0c7:e1f7:948e:d8d5])
        by smtp.gmail.com with ESMTPSA id s62sm6998869pfb.148.2021.03.19.21.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 21:16:34 -0700 (PDT)
From:   Nicolas Boichat <drinkcat@chromium.org>
To:     stable@vger.kernel.org
Cc:     groeck@chromium.org, Nicolas Boichat <drinkcat@chromium.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Axtens <dja@axtens.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        clang-built-linux@googlegroups.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [for-stable-4.19 PATCH v2 0/2] Backport patches to fix KASAN+LKDTM with recent clang on ARM64
Date:   Sat, 20 Mar 2021 12:16:24 +0800
Message-Id: <20210320041626.885806-1-drinkcat@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport 2 patches that are required to make KASAN+LKDTM work
with recent clang (patch 2/2 has a complete description).
Tested on our chromeos-4.19 branch.
Also compile tested on x86-64 and arm64 with gcc this time
around.

Patch 1/2 adds a guard around noinstr that matches upstream,
to prevent a build issue, and has some minor context conflicts.
Patch 2/2 is a clean backport.

These patches have been merged to 5.4 stable already. We might
need to backport to older stable branches, but this is what I
could test for now.

Changes in v2:
 - Guard noinstr macro by __KERNEL__ && !__ASSEMBLY__ to prevent
   expansion in linker script and match upstream.

Mark Rutland (1):
  lkdtm: don't move ctors to .rodata

Thomas Gleixner (1):
  vmlinux.lds.h: Create section for protection against instrumentation

 arch/powerpc/kernel/vmlinux.lds.S |  1 +
 drivers/misc/lkdtm/Makefile       |  2 +-
 drivers/misc/lkdtm/rodata.c       |  2 +-
 include/asm-generic/sections.h    |  3 ++
 include/asm-generic/vmlinux.lds.h | 10 ++++++
 include/linux/compiler.h          | 54 +++++++++++++++++++++++++++++++
 include/linux/compiler_types.h    |  6 ++++
 scripts/mod/modpost.c             |  2 +-
 8 files changed, 77 insertions(+), 3 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730FA3E865E
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 01:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhHJXS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 19:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbhHJXS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 19:18:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64BBC061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 16:18:04 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id on10-20020a17090b1d0ab029017773c0b9aeso3534276pjb.1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 16:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E8Aj/fL5iGPfl9iYHtcSD7Ifgdxa0r41M3PNgmyPyak=;
        b=p/c5xE+4cJjJDX/cyiXUQQUoZPUgIToX7/lcdt/0nChru9fCTjdkOQKWFnEfc89zTy
         7K5QPv+YdxATjxQmrBaMiRwC7OpCbfFfPqX+tkkOp6CKHA+kQo7jUi1xCJu8zWlDTzCY
         j1m0sn8wybItzq3EUXjbnbbkJmbEslCtaPv+pWGLIgex3aJti2NzMB4uYj2A1Mo0n1jj
         1VE5IleS3SOEF7sp684nd2fkMH7gnKe1oBP0qeiPiIMhoou83/SHhkq9Tq8gW1uIQS6O
         BuA6CYlJma4k0TrNf3WfIWe3hLE7litvV1Se3P+FxnlaXZwMjWkAVNZoJVsAkX3gfaGW
         l7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E8Aj/fL5iGPfl9iYHtcSD7Ifgdxa0r41M3PNgmyPyak=;
        b=W4Z2viarUc8ZuTi9HXuIURyGEUESQapgJ8zZ2yt8dVRz8Hvq7StB4pU7JNqFR3pKtG
         FW0h4iwYlZefwUwfZgGN5QE4/E2weOUzc0wN7w78pw0pNJYkvX+be/R/GIInG+FN8Egv
         H7w1pktgxdFj3s0cRSkMFQNAFQmJ8lvHcrnhWXY4IJYvCZbqt1ROwnTMMkCbEHbkJ+bl
         GOzRg1r5M/MzODcPZ+vUtNyM6xH161okX/EzX2auwd6PFmeXuGFkn3AlP0NHd4cSUW1z
         QTg4Pp1Dpel7g+39bRq80n6Jqn/mX/JejeqNkQ8uGX6hYvPDpXMf5te5fQdkqd2tHdc/
         9R8A==
X-Gm-Message-State: AOAM530rMH37v774gQYR9LPLp1HuFdzw93aQXWKrkUiyoRo2XN0dxhVs
        1GJq4e/wOC1TAk+yFyOzPxZdUn+5NQ==
X-Google-Smtp-Source: ABdhPJyb51vgZGJ83rqquzLnLshtObvbPMhnS6d+bkM6fAJDJP8gMjmKZgFb1YsAnccZYEE6WYj9iue2xg==
X-Received: from adelg-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:d1f])
 (user=adelg job=sendgmr) by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id
 b20-20020a056a000a94b02903841dc67012mr31128194pfl.53.1628637484118; Tue, 10
 Aug 2021 16:18:04 -0700 (PDT)
Date:   Tue, 10 Aug 2021 23:17:55 +0000
Message-Id: <20210810231755.1743524-1-adelg@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2] arm64: clean vdso & vdso32 files
From:   Andrew Delgadillo <adelg@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Delgadillo <adelg@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
changes the cleaning behavior of arm64's vdso files, in that vdso.lds,
vdso.so, and vdso.so.dbg are not removed upon a 'make clean/mrproper':

$ make defconfig ARCH=arm64
$ make ARCH=arm64
$ make mrproper ARCH=arm64
$ git clean -nxdf
Would remove arch/arm64/kernel/vdso/vdso.lds
Would remove arch/arm64/kernel/vdso/vdso.so
Would remove arch/arm64/kernel/vdso/vdso.so.dbg

To remedy this, manually descend into arch/arm64/kernel/vdso upon
cleaning.

After this commit:
$ make defconfig ARCH=arm64
$ make ARCH=arm64
$ make mrproper ARCH=arm64
$ git clean -nxdf
<empty>

Similar results are obtained for the vdso32 equivalent.

Signed-off-by: Andrew Delgadillo <adelg@google.com>
Cc: stable@vger.kernel.org
---
Changelog since v1:
- Also descend into vdso32 upon archclean
- Add stable to cc in signoff area

 arch/arm64/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b52481f0605d..02997b253dee 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -181,6 +181,8 @@ archprepare:
 # We use MRPROPER_FILES and CLEAN_FILES now
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso
+	$(Q)$(MAKE) $(clean)=arch/arm64/kernel/vdso32
 
 ifeq ($(KBUILD_EXTMOD),)
 # We need to generate vdso-offsets.h before compiling certain files in kernel/.
-- 
2.32.0.605.g8dce9f2422-goog


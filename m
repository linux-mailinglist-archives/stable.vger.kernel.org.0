Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B792F8561
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 20:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbhAOT1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 14:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbhAOT1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 14:27:17 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038EC061757;
        Fri, 15 Jan 2021 11:26:36 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id az16so4505012qvb.5;
        Fri, 15 Jan 2021 11:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wI2uI3+2FzYpX+KeqH6pO7iQOIAE34VnV+1RkmvqBfE=;
        b=mf3PqmEpDtpRpnPWuxmzKuTTUKWRTeDqffC2DgmZRyE897531vZpY6Ec/xn0aw6uLS
         B/PJnjvnmJBbEpy4hcX2//BSi1M+y5f7MM2KIUmE/Y4roQ/xOBvznSJE6IhOy0WXYtF2
         QXLNLb8QqeY1wECnN6HH92dSG5kEX6FxfU1GwvMRGSDMv7B0+JlPyGPCUS7FN1+sq4K+
         XoJoeAy0xZof8LFCbUi1/YKETUIvVMcDtraSR9WffmgBjNkM2ycupbY1i7CgI2Gy8eMS
         GQk3OR7ATRpe31boj0xPqgdiimsuXyR7QAsuPBY1qKe4ki4nUqGee2Tpohhe0I0moUA4
         O2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wI2uI3+2FzYpX+KeqH6pO7iQOIAE34VnV+1RkmvqBfE=;
        b=JGbmRzapTLwNliNIEjxvAGdKBXheD0TnKBB9IKqwlX6qu07p/53YS+QXTyQc+uGD2d
         +fcECgDoueTAhcgxXmaM9JNsSz1AZexuCfwDV4kVIyh6zsrlCAVt+D6NqYJHJ8zCy9V9
         PQu84VMrOwqOz/5T7yV3RIu+Ov0U79kNGdFlGHMUyWYhgIYy18/8eFIBD7MGsrIlF+nT
         zjW4LozFK8/pTBNheauwPQqOeIfua4nuaiZrW+hJOh/kCxj9+lN1FtqnBLEvEfzUUdSc
         Zpw27nsjGARyBXdnVbEyg4DyR+oTs9wEPptydIN3BU+NPXJWyYFpIAV2lC1leyqbnv9x
         bstQ==
X-Gm-Message-State: AOAM530J2wAlIxJnsI5+bkF5SVdnsb+okgDCo54UHGovxNXWcxxb+fo9
        iElzgEKjMku/uV+MWS7hfhk=
X-Google-Smtp-Source: ABdhPJzBldBdArrpCk82v9Vpj5Nezb/uflqHljq+TNKRFLYxL46if+OX4UMTE0jlWTT3LjohGVqZTw==
X-Received: by 2002:a05:6214:533:: with SMTP id x19mr13839323qvw.20.1610738796075;
        Fri, 15 Jan 2021 11:26:36 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id w42sm2557457qtw.22.2021.01.15.11.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:26:35 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out '--target='
Date:   Fri, 15 Jan 2021 12:26:22 -0700
Message-Id: <20210115192622.3828545-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
cflags") allowed the '--target=' flag from the main Makefile to filter
through to the vDSO. However, it did not bring any of the other clang
specific flags for controlling the integrated assembler and the GNU
tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
Without these, we will get a warning (visible with tinyconfig):

arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
compilation unit
.pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
^
arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
compilation unit
 .section .mips_abiflags, "a"
 ^

All of these flags are bundled up under CLANG_FLAGS in the main Makefile
and exported so that they can be added to Makefiles that set their own
CFLAGS. Use this value instead of filtering out '--target=' so there is
no warning and all of the tools are properly used.

Cc: stable@vger.kernel.org
Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
Link: https://github.com/ClangBuiltLinux/linux/issues/1256
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/mips/vdso/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 5810cc12bc1d..2131d3fd7333 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -16,16 +16,13 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
 ifndef CONFIG_64BIT
 ccflags-vdso += -DBUILD_VDSO32
 endif
 
-ifdef CONFIG_CC_IS_CLANG
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 #
 # The -fno-jump-tables flag only prevents the compiler from generating
 # jump tables but does not prevent the compiler from emitting absolute

base-commit: 7b490a8ab0f2d3ab8d838a4ff22ae86edafd34a1
-- 
2.30.0


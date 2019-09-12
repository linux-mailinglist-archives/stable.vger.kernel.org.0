Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5381B096D
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 09:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfILHWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 03:22:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35745 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfILHWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 03:22:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id n10so6288149wmj.0
        for <stable@vger.kernel.org>; Thu, 12 Sep 2019 00:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CeyyRMj4arJ5MswszulwIkFPEnYjRfvfQK3SvLqDb4=;
        b=uHa+xmaO71Z9V5NADf0EW/N3p8Lfp6Gh70zeI1lwSwUqnLY3Zq8o1tjnDFog8Fx0E0
         T3sd/B5YgC7nA96ysGGDf66YduYOzOEEDWDkuDyvgS3eCy1+s21RXjsXzIhnnfOlOabW
         BqZqKzxAYHs7z2i6TGG/V5/ItKvdZrPvtUOEU77ZUANzbu1SRp3MbI/lf/Ofd1ZcB+Jk
         79ipOSIQVRd8HjL+wLAyz6Hh23WC5nqjMu7ULFCO5XtSarCtayxQ07lC8tT8mAIRAIsE
         AbaQ0E+iWOhLD9aVhX1/HkUKJEKZ46XP0FfuL0dX2EcKB1GVv1fQS+q7knQCCW07waJn
         TVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CeyyRMj4arJ5MswszulwIkFPEnYjRfvfQK3SvLqDb4=;
        b=O6VyFQ9ekJmIchUNaGJALEb2qqlNMI9J/NuqB1muuP1SQLbRLblarwdJv0X5ujxWw1
         1T+Om+F/GLrOyJd3Mwj1Klc8nJ7jHuyDDM5Ls0mfcad3lT9tiWrUeR3PYrfOE6VaA4+1
         Ybz8nDZx+pFlJOS9yVakFpgUP+DcKZDX7XbqfRZkM3ZV4NShBKSyRyO8zOCbnCHVY6/5
         gX3inrvqB9NV+X9SpBxsgChgS29ubmfV78ll8k/+8ZlgY1PcPV2mHc+EggqRaxwD9yPy
         K3y9yOIMsWroir8WQnyk14y6lE3CqaCiTgKXfz3dQeNS+HL69dijwBR2G3dhMxtmOi7A
         B6bA==
X-Gm-Message-State: APjAAAXPqQ7Nuz5aBqkcuUsoYRxoFFf7YvUKwBMRLQLBtmyLkKdFQJyK
        4kmpTynOZM5QhWewVwCwP7o=
X-Google-Smtp-Source: APXvYqxe/tEJkeMm4EqKT/2Wy92fFk11UiYijbXGUlV2E0QrZ2KOdbdso3/sXFTOWlF7WUwp2RRm8w==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr7336940wmd.104.1568272936590;
        Thu, 12 Sep 2019 00:22:16 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id b144sm5382465wmb.3.2019.09.12.00.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 00:22:16 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ilie Halip <ilie.halip@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.4] x86, boot: Remove multiple copy of static function sanitize_boot_params()
Date:   Thu, 12 Sep 2019 00:21:48 -0700
Message-Id: <20190912072146.68410-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 8c5477e8046ca139bac250386c08453da37ec1ae upstream.

Kernel build warns:
 'sanitize_boot_params' defined but not used [-Wunused-function]

at below files:
  arch/x86/boot/compressed/cmdline.c
  arch/x86/boot/compressed/error.c
  arch/x86/boot/compressed/early_serial_console.c
  arch/x86/boot/compressed/acpi.c

That's becausethey each include misc.h which includes a definition of
sanitize_boot_params() via bootparam_utils.h.

Remove the inclusion from misc.h and have the c file including
bootparam_utils.h directly.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/1563283092-1189-1-git-send-email-zhenzhong.duan@oracle.com
[nc: Fixed conflict around lack of 67b6662559f7f]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Hi Greg and Sasha,

Please consider applying this to 4.4 as it resolves a compilation error
with clang on 4.4 and it has already been applied to 4.9 and newer:

https://travis-ci.com/ClangBuiltLinux/continuous-integration/jobs/232287034

https://github.com/ClangBuiltLinux/linux/issues/654

Thanks to Ilie Halip for debugging this; TL;DR: clang pretends that it
is GCC 4.2.1 for glibc compatibility and this trips up a definition of
memcpy for GCC < 4.3. This is not an issue on mainline because GCC 4.6
is the earliest supported GCC version so that code was removed and this
patch resolves it because string.h redefines memcpy to a proper version.

 arch/x86/boot/compressed/misc.c | 1 +
 arch/x86/boot/compressed/misc.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 16df89c30c20..1e5b68228aff 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -11,6 +11,7 @@
 
 #include "misc.h"
 #include "../string.h"
+#include <asm/bootparam_utils.h>
 
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4abb284a5b9c..bce182708814 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/boot.h>
 #include <asm/bootparam.h>
-#include <asm/bootparam_utils.h>
 
 #define BOOT_BOOT_H
 #include "../ctype.h"
-- 
2.23.0


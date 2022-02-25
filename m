Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111254C48C4
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiBYP0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiBYPZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:25:58 -0500
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Feb 2022 07:25:19 PST
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08BDF1DA032
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=eDop8
        f+Nx2EEhFasQM34tg+cQu/9B49JPWKEO/ld2hs=; b=CU6h1czazNEtDvmvourSL
        Ria0ThJZ1Nuu+4ZHTc+SjLgMys17aMKkakYGN8V+wuB/XrNFd288+8c/DcV1r7UV
        jRZPKC2k0ydJ4gFYgY4HOIhGMagRiMFGjjGpisR3JWPVmjr+oULpHBsfph/t8sGd
        tzodemWHra6EOINIsohz8U=
Received: from localhost.localdomain (unknown [14.221.173.100])
        by smtp9 (Coremail) with SMTP id DcCowAD3rBMk8RhinizFAA--.18407S2;
        Fri, 25 Feb 2022 23:09:25 +0800 (CST)
From:   logic_wei@163.com
To:     coderlogicwei@gmail.com
Cc:     Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 2/5] Makefile.extrawarn: Move -Wunaligned-access to W=1
Date:   Fri, 25 Feb 2022 23:09:22 +0800
Message-Id: <20220225150922.927113-1-logic_wei@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAD3rBMk8RhinizFAA--.18407S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFW8uw43AFyrXr15Gr45Jrb_yoW8AF4fpF
        WxCF409a15ZF4vkasrKay7AF4DXaykC3yjg3Wjgr1UZFnrZr1fWw4Ikrs093W2vr4DArWU
        Jr4Ig3WkKFyqy37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFdgAUUUUU=
X-Originating-IP: [14.221.173.100]
X-CM-SenderInfo: 5orjxupbzhxqqrwthudrp/1tbiNwWyulWBmf2j1QAAs8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

-Wunaligned-access is a new warning in clang that is default enabled for
arm and arm64 under certain circumstances within the clang frontend (see
LLVM commit below). On v5.17-rc2, an ARCH=arm allmodconfig build shows
1284 total/70 unique instances of this warning (most of the instances
are in header files), which is quite noisy.

To keep a normal build green through CONFIG_WERROR, only show this
warning with W=1, which will allow automated build systems to catch new
instances of the warning so that the total number can be driven down to
zero eventually since catching unaligned accesses at compile time would
be generally useful.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
Link: https://github.com/ClangBuiltLinux/linux/issues/1569
Link: https://github.com/ClangBuiltLinux/linux/issues/1576
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d53825503874..8be892887d71 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -51,6 +51,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
+KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 endif
 
 endif
-- 
2.25.1


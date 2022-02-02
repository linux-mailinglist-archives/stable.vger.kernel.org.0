Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D96C4A7B78
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 00:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiBBXHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 18:07:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36946 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiBBXHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 18:07:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D70CF6166C;
        Wed,  2 Feb 2022 23:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9637CC004E1;
        Wed,  2 Feb 2022 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643843230;
        bh=qxCHvIg/XmXSNkQEWjgnOIlMgC9MvQaoNnK07mww1MA=;
        h=From:To:Cc:Subject:Date:From;
        b=D/vNnMsfjBEWN5uwhwwuz1iTGN088N+vXTPxamkIrjCb7cw+t+ZyYiOUby1nDKYVt
         H3DXNYcV3sA+uXJK1CxbWg0uM69RZo+1kfqSRiB60ffBYyLhJDCIPdlugR6LexsmsA
         qNMyF9xinPFKKILN5pKmcBtcPxA97gXnQe+hJGDNhAOS9zVxnZi0Mb09MF1/x9j0Z5
         2KUO3svoi9aghC2FDkggfl8M5tuy4gquTVRy1x5PYfqE2GKhl6M0F06JBolj8t4KP5
         MsEti2DkLLHZYDIt8pznZKki/ReN852avq6iBGT3Dmda9LjsKjwwl5O05sIg6cZyIi
         ZTT6OyiL4BoBA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] Makefile.extrawarn: Move -Wunaligned-access to W=1
Date:   Wed,  2 Feb 2022 16:05:16 -0700
Message-Id: <20220202230515.2931333-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

v1 -> v2: https://lore.kernel.org/r/20220201232229.2992968-1-nathan@kernel.org/

* Move to W=1 instead of W=2 so that new instances are caught (Arnd).
* Add links to the ClangBuiltLinux issue tracker.

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

base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
-- 
2.35.1


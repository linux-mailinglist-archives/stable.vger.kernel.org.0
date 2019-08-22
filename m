Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04AD99C15
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392213AbfHVRbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404557AbfHVRZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:59 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA542341C;
        Thu, 22 Aug 2019 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494758;
        bh=rSE9tySoDK9NcP8IePbKZZLmlTlkfFUSKzFTEfDHgZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gI1RuaXUe3J4qsHBneA02wtP4kaec7fX88qtesbyn0hprRPYtb+PDqC5kXYB0vjsi
         aha0aUe72Sb15VGpswv2TWn2mAOM5z7X8OIJ0luxOSnQ1HTc4m1nbws76IG83UlFQw
         Sxf/Gut4FJH0/VJG9iiUxq1ACxhm20lg9Cq0Nn+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Smith <peter.smith@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/85] kbuild: Check for unknown options with cc-option usage in Kconfig and clang
Date:   Thu, 22 Aug 2019 10:19:15 -0700
Message-Id: <20190822171733.116438013@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e8de12fb7cde2c85bc31097cd098da79a4818305 ]

If the particular version of clang a user has doesn't enable
-Werror=unknown-warning-option by default, even though it is the
default[1], then make sure to pass the option to the Kconfig cc-option
command so that testing options from Kconfig files works properly.
Otherwise, depending on the default values setup in the clang toolchain
we will silently assume options such as -Wmaybe-uninitialized are
supported by clang, when they really aren't.

A compilation issue only started happening for me once commit
589834b3a009 ("kbuild: Add -Werror=unknown-warning-option to
CLANG_FLAGS") was applied on top of commit b303c6df80c9 ("kbuild:
compute false-positive -Wmaybe-uninitialized cases in Kconfig"). This
leads kbuild to try and test for the existence of the
-Wmaybe-uninitialized flag with the cc-option command in
scripts/Kconfig.include, and it doesn't see an error returned from the
option test so it sets the config value to Y. Then the Makefile tries to
pass the unknown option on the command line and
-Werror=unknown-warning-option catches the invalid option and breaks the
build. Before commit 589834b3a009 ("kbuild: Add
-Werror=unknown-warning-option to CLANG_FLAGS") the build works fine,
but any cc-option test of a warning option in Kconfig files silently
evaluates to true, even if the warning option flag isn't supported on
clang.

Note: This doesn't change cc-option usages in Makefiles because those
use a different rule that includes KBUILD_CFLAGS by default (see the
__cc-option command in scripts/Kbuild.incluide). The KBUILD_CFLAGS
variable already has the -Werror=unknown-warning-option flag set. Thanks
to Doug for pointing out the different rule.

[1] https://clang.llvm.org/docs/DiagnosticsReference.html#wunknown-warning-option
Cc: Peter Smith <peter.smith@linaro.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kconfig.include | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index dad5583451afb..3b2861f47709b 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -20,7 +20,7 @@ success = $(if-success,$(1),y,n)
 
 # $(cc-option,<flag>)
 # Return y if the compiler supports <flag>, n otherwise
-cc-option = $(success,$(CC) -Werror $(1) -E -x c /dev/null -o /dev/null)
+cc-option = $(success,$(CC) -Werror $(CLANG_FLAGS) $(1) -E -x c /dev/null -o /dev/null)
 
 # $(ld-option,<flag>)
 # Return y if the linker supports <flag>, n otherwise
-- 
2.20.1




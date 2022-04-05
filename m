Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2C4F42F5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382511AbiDEMPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbiDEKgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:36:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D653B73;
        Tue,  5 Apr 2022 03:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C5518CE1C9D;
        Tue,  5 Apr 2022 10:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4DEC385A1;
        Tue,  5 Apr 2022 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154113;
        bh=A/hAMMRh3XJNdD9x1AAtbacK618VtXEYBp3Ix1ZXMfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToM9a8timaHkWFGh2Msw9MGcQzRutO22AXWXSo99BHhN5WHLsMJSoS/qsj7brT+M/
         To9C+aPukQHXd4UHsQGIpGNKadbToc904pg2YIkN1z1v9KS/tf7dm7NZlDQ6XspiWl
         HPqlDY3LrdnylwT5VifHHdgvcfVO44+C1eN6ba7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Brown <matthew.brown.dev@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 463/599] lib/raid6/test/Makefile: Use $(pound) instead of \# for Make 4.3
Date:   Tue,  5 Apr 2022 09:32:37 +0200
Message-Id: <20220405070312.605610993@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 633174a7046ec3b4572bec24ef98e6ee89bce14b ]

Buidling raid6test on Ubuntu 21.10 (ppc64le) with GNU Make 4.3 shows the
errors below:

    $ cd lib/raid6/test/
    $ make
    <stdin>:1:1: error: stray ‘\’ in program
    <stdin>:1:2: error: stray ‘#’ in program
    <stdin>:1:11: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ \
        before ‘<’ token

    [...]

The errors come from the HAS_ALTIVEC test, which fails, and the POWER
optimized versions are not built. That’s also reason nobody noticed on the
other architectures.

GNU Make 4.3 does not remove the backslash anymore. From the 4.3 release
announcment:

> * WARNING: Backward-incompatibility!
>   Number signs (#) appearing inside a macro reference or function invocation
>   no longer introduce comments and should not be escaped with backslashes:
>   thus a call such as:
>     foo := $(shell echo '#')
>   is legal.  Previously the number sign needed to be escaped, for example:
>     foo := $(shell echo '\#')
>   Now this latter will resolve to "\#".  If you want to write makefiles
>   portable to both versions, assign the number sign to a variable:
>     H := \#
>     foo := $(shell echo '$H')
>   This was claimed to be fixed in 3.81, but wasn't, for some reason.
>   To detect this change search for 'nocomment' in the .FEATURES variable.

So, do the same as commit 9564a8cf422d ("Kbuild: fix # escaping in .cmd
files for future Make") and commit 929bef467771 ("bpf: Use $(pound) instead
of \# in Makefiles") and define and use a $(pound) variable.

Reference for the change in make:
https://git.savannah.gnu.org/cgit/make.git/commit/?id=c6966b323811c37acedff05b57

Cc: Matt Brown <matthew.brown.dev@gmail.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/test/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index a4c7cd74cff5..4fb7700a741b 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -4,6 +4,8 @@
 # from userspace.
 #
 
+pound := \#
+
 CC	 = gcc
 OPTFLAGS = -O2			# Adjust as desired
 CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
@@ -42,7 +44,7 @@ else ifeq ($(HAS_NEON),yes)
         OBJS   += neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o recov_neon_inner.o
         CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
 else
-        HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
+        HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
                          gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
         ifeq ($(HAS_ALTIVEC),yes)
                 CFLAGS += -I../../../arch/powerpc/include
-- 
2.34.1




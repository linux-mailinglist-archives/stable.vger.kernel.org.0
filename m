Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905E94F3B3E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbiDELwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356732AbiDEKYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55592BF516;
        Tue,  5 Apr 2022 03:08:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D51BCB81C89;
        Tue,  5 Apr 2022 10:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CACDC385A6;
        Tue,  5 Apr 2022 10:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153332;
        bh=s9JZTHU4ISnxMDiWXbfQdfcWMtbuXYw/drMU+c7jGpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+smV24ZXXGg6NQHDSCicgF2s41V5TA6S2CKe3ZNmlWRAavfXwgjwWPYJDS3kU35d
         4Qd3W/BttlaxPjs9MNt61/7+tAPM1e+1W1tEix8AO4lxpHS+5gGgXvUHauT5/zCk8t
         uOErlje415YkKqgnc+FTFHlUmRKTicaov0MvQdPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Guenter Roeck <groeck@google.com>,
        Shuah Khan <shuah@kernel.org>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/599] selftests, x86: fix how check_cc.sh is being invoked
Date:   Tue,  5 Apr 2022 09:27:59 +0200
Message-Id: <20220405070304.347142989@linuxfoundation.org>
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

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit ef696f93ed9778d570bd5ac58414421cdd4f1aab ]

The $(CC) variable used in Makefiles could contain several arguments
such as "ccache gcc".  These need to be passed as a single string to
check_cc.sh, otherwise only the first argument will be used as the
compiler command.  Without quotes, the $(CC) variable is passed as
distinct arguments which causes the script to fail to build trivial
programs.

Fix this by adding quotes around $(CC) when calling check_cc.sh to pass
the whole string as a single argument to the script even if it has
several words such as "ccache gcc".

Link: https://lkml.kernel.org/r/d0d460d7be0107a69e3c52477761a6fe694c1840.1646991629.git.guillaume.tucker@collabora.com
Fixes: e9886ace222e ("selftests, x86: Rework x86 target architecture detection")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Tested-by: "kernelci.org bot" <bot@kernelci.org>
Reviewed-by: Guenter Roeck <groeck@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile  | 6 +++---
 tools/testing/selftests/x86/Makefile | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 2cf32e6b376e..01ec6876e8f5 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -40,9 +40,9 @@ TEST_GEN_FILES += userfaultfd
 TEST_GEN_FILES += khugepaged
 
 ifeq ($(MACHINE),x86_64)
-CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_32bit_program.c -m32)
-CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_64bit_program.c)
-CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh $(CC) ../x86/trivial_program.c -no-pie)
+CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
+CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
+CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
 TARGETS := protection_keys
 BINARIES_32 := $(TARGETS:%=%_32)
diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 6703c7906b71..f1b675a4040b 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -6,9 +6,9 @@ include ../lib.mk
 .PHONY: all all_32 all_64 warn_32bit_failure clean
 
 UNAME_M := $(shell uname -m)
-CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) trivial_32bit_program.c -m32)
-CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) trivial_64bit_program.c)
-CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) trivial_program.c -no-pie)
+CAN_BUILD_I386 := $(shell ./check_cc.sh "$(CC)" trivial_32bit_program.c -m32)
+CAN_BUILD_X86_64 := $(shell ./check_cc.sh "$(CC)" trivial_64bit_program.c)
+CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh "$(CC)" trivial_program.c -no-pie)
 
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt test_mremap_vdso \
 			check_initial_reg_state sigreturn iopl ioperm \
-- 
2.34.1




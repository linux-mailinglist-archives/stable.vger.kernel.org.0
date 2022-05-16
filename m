Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE05528FA4
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242150AbiEPTzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348737AbiEPTxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:53:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413A47054;
        Mon, 16 May 2022 12:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3EF1B81614;
        Mon, 16 May 2022 19:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AC1C34100;
        Mon, 16 May 2022 19:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730534;
        bh=Z435rSSZoQChbpxNYBpzg/gF8UBv8oCGDHiBW6HZDoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDCZlQ+5CKpAw+Sgq13ZoERpPIhtN2f8VoaqHGjyewVFobouuB51qEtmfxns9kuj/
         aVu+geuScDMTiLNGUUZOj+DjPSNRvw9tJrj2knrflHl5i6lWDVGw55SlYnl/g+OUbB
         ZHWM8rm6NDhMX5MlKwjeMjoMGH7y5/wO7usokpoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>,
        Nico Pache <npache@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/102] selftests: vm: Makefile: rename TARGETS to VMTARGETS
Date:   Mon, 16 May 2022 21:36:03 +0200
Message-Id: <20220516193624.837411284@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Savitz <jsavitz@redhat.com>

[ Upstream commit 41c240099fe09377b6b9f8272e45d2267c843d3e ]

The tools/testing/selftests/vm/Makefile uses the variable TARGETS
internally to generate a list of platform-specific binary build targets
suffixed with _{32,64}.  When building the selftests using its own
Makefile directly, such as via the following command run in a kernel tree:

One receives an error such as the following:

make: Entering directory '/root/linux/tools/testing/selftests'
make --no-builtin-rules ARCH=x86 -C ../../.. headers_install
make[1]: Entering directory '/root/linux'
  INSTALL ./usr/include
make[1]: Leaving directory '/root/linux'
make[1]: Entering directory '/root/linux/tools/testing/selftests/vm'
make[1]: *** No rule to make target 'vm.c', needed by '/root/linux/tools/testing/selftests/vm/vm_64'.  Stop.
make[1]: Leaving directory '/root/linux/tools/testing/selftests/vm'
make: *** [Makefile:175: all] Error 2
make: Leaving directory '/root/linux/tools/testing/selftests'

The TARGETS variable passed to tools/testing/selftests/Makefile collides
with the TARGETS used in tools/testing/selftests/vm/Makefile, so rename
the latter to VMTARGETS, eliminating the collision with no functional
change.

Link: https://lkml.kernel.org/r/20220504213454.1282532-1-jsavitz@redhat.com
Fixes: f21fda8f6453 ("selftests: vm: pkeys: fix multilib builds for x86")
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index a7fde142e814..d8ae7cc01274 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -54,9 +54,9 @@ CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_prog
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
-TARGETS := protection_keys
-BINARIES_32 := $(TARGETS:%=%_32)
-BINARIES_64 := $(TARGETS:%=%_64)
+VMTARGETS := protection_keys
+BINARIES_32 := $(VMTARGETS:%=%_32)
+BINARIES_64 := $(VMTARGETS:%=%_64)
 
 ifeq ($(CAN_BUILD_WITH_NOPIE),1)
 CFLAGS += -no-pie
@@ -109,7 +109,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
@@ -117,7 +117,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
 # x86_64 users should be encouraged to install 32-bit libraries
-- 
2.35.1




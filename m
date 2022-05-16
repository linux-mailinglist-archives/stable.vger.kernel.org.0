Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99215290FD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiEPUIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244096AbiEPUAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F45345043;
        Mon, 16 May 2022 12:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4CDFB8161C;
        Mon, 16 May 2022 19:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE79C385AA;
        Mon, 16 May 2022 19:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730881;
        bh=fpxOQ0rPho95+qYGMbd1myF+tFU1OPuQFXf6fsc2o4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTl5vTZV9uwJeH1sOcBYm2LMqYOkAPbkRECKR8uDUURhhwxz9Yhy6BTdqFKX3FsFZ
         B2kmWHOWrfC4WoFciAsZoteJNZsKvNiH8gIaBaKR1EERTCspNRIVGz5qFBPpCpCR+V
         +U9K0bOF7UTe7bjfYh6jjgcL2H7kZm7tI5WzXVUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 033/114] arm64: vdso: fix makefile dependency on vdso.so
Date:   Mon, 16 May 2022 21:36:07 +0200
Message-Id: <20220516193626.441761277@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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

From: Joey Gouly <joey.gouly@arm.com>

[ Upstream commit 205f3991a273cac6008ef4db3d1c0dc54d14fb56 ]

There is currently no dependency for vdso*-wrap.S on vdso*.so, which means that
you can get a build that uses a stale vdso*-wrap.o.

In commit a5b8ca97fbf8, the file that includes the vdso.so was moved and renamed
from arch/arm64/kernel/vdso/vdso.S to arch/arm64/kernel/vdso-wrap.S, when this
happened the Makefile was not updated to force the dependcy on vdso.so.

Fixes: a5b8ca97fbf8 ("arm64: do not descend to vdso directories twice")
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220510102721.50811-1-joey.gouly@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/Makefile        | 4 ++++
 arch/arm64/kernel/vdso/Makefile   | 3 ---
 arch/arm64/kernel/vdso32/Makefile | 3 ---
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 88b3e2a21408..db557856854e 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -74,6 +74,10 @@ obj-$(CONFIG_ARM64_MTE)			+= mte.o
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
 
+# Force dependency (vdso*-wrap.S includes vdso.so through incbin)
+$(obj)/vdso-wrap.o: $(obj)/vdso/vdso.so
+$(obj)/vdso32-wrap.o: $(obj)/vdso32/vdso.so
+
 obj-y					+= probes/
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 172452f79e46..ac1964ebed1e 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -52,9 +52,6 @@ GCOV_PROFILE := n
 targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
-# Force dependency (incbin is bad)
-$(obj)/vdso.o : $(obj)/vdso.so
-
 # Link rule for the .so file, .lds has to be first
 $(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 6c01b63ff56d..2c2036eb0df7 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -130,9 +130,6 @@ obj-vdso := $(c-obj-vdso) $(c-obj-vdso-gettimeofday) $(asm-obj-vdso)
 targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
-# Force dependency (vdso.s includes vdso.so through incbin)
-$(obj)/vdso.o: $(obj)/vdso.so
-
 include/generated/vdso32-offsets.h: $(obj)/vdso.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
-- 
2.35.1




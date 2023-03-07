Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0376AF4A5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjCGTSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjCGTRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C46591
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4386E6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2ACC433EF;
        Tue,  7 Mar 2023 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215707;
        bh=mZrWDXAGQ1Q53BwuIWk2aT+WeZnexLukaJbCZOdjrvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLSQg5ZNjkiCPKthXj3CRq2WLwJV3PPIacW7dS0GyQsgk0xp0RhW5YEfo7od2ndCx
         K4Tx+rGQUS3tB0P48anikOzcohQEma7m5jteHG6aZhRTrmbsdP3+GszoGtHHmyLd6l
         BhSKMZKGKhst6TDCe98V0YrdZ6JMaOve4KbgAok0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/567] s390/vdso: remove -nostdlib compiler flag
Date:   Tue,  7 Mar 2023 18:01:24 +0100
Message-Id: <20230307165920.958546375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 7b737adc10d269e7fdf714ae2caa2281b6a801cf ]

The -nostdlib option requests the compiler to not use the standard
system startup files or libraries when linking. It is effective only
when $(CC) is used as a linker driver.

Since commit 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to
link vDSO"), $(LD) is directly used, hence -nostdlib is unneeded.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20211107162111.323701-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: fd8589dce810 ("s390/vdso: Drop '-shared' from KBUILD_CFLAGS_64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso32/Makefile | 2 +-
 arch/s390/kernel/vdso64/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index e3e6ac5686df5..245bddfe9bc0e 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -22,7 +22,7 @@ KBUILD_AFLAGS_32 += -m31 -s
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
 
-LDFLAGS_vdso32.so.dbg += -fPIC -shared -nostdlib -soname=linux-vdso32.so.1 \
+LDFLAGS_vdso32.so.dbg += -fPIC -shared -soname=linux-vdso32.so.1 \
 	--hash-style=both --build-id=sha1 -melf_s390 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 0dea82b87e54b..9e2b95a222a98 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -26,7 +26,7 @@ KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
-ldflags-y := -fPIC -shared -nostdlib -soname=linux-vdso64.so.1 \
+ldflags-y := -fPIC -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)
-- 
2.39.2




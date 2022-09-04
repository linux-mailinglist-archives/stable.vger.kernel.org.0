Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB105AC472
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIDNTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 09:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIDNTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 09:19:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB7D356EF;
        Sun,  4 Sep 2022 06:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E852B80D70;
        Sun,  4 Sep 2022 13:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A3DC433C1;
        Sun,  4 Sep 2022 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662297555;
        bh=Uuz712e5muW17Xu4mJ/Dom3DkyTuFpudVaqCI/aDq1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNtytRh1BI2S/Ya5qmUSNtsTTP3XP3AB4Kds8aIQADwDTXESu4iW8p9VpGv+Fl4KY
         WOLXWJKblrh3ODEf8Z7AlawUp3K1nRAWEGN/gYZcVMvK3Zj4ImtbFu3M/tYaov5R2i
         XM4s129b/5aDni6Y+s5UsEHSSIbn5Np6MmNFe+2ytIFq/5kaiZTrO64zKqtK3ODeoN
         /ViG/FlrTxik0YLmk35+qrULNGYVoEPBPBrWFIl/N/DdtlT7VBqDVsXN3CQtYTpasD
         JvT23f8orY4+Mv2ZSjOYiYj3ZphZjov2Sz8q9smDkBUK2tt/HV2OqfLvlfZwWLCu7y
         GjDo6AbvOHeZQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: [PATCH stable 5.15 1/2] kbuild: Unify options for BTF generation for vmlinux and modules
Date:   Sun,  4 Sep 2022 15:19:00 +0200
Message-Id: <20220904131901.13025-2-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220904131901.13025-1-jolsa@kernel.org>
References: <20220904131901.13025-1-jolsa@kernel.org>
MIME-Version: 1.0
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

From: Jiri Olsa <jolsa@redhat.com>

commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.

Using new PAHOLE_FLAGS variable to pass extra arguments to
pahole for both vmlinux and modules BTF data generation.

Adding new scripts/pahole-flags.sh script that detect and
prints pahole options.

[ fixed issues found by kernel test robot ]

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211029125729.70002-1-jolsa@kernel.org
---
 Makefile                  |  3 +++
 scripts/Makefile.modfinal |  2 +-
 scripts/link-vmlinux.sh   | 11 +----------
 scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
 4 files changed, 25 insertions(+), 11 deletions(-)
 create mode 100755 scripts/pahole-flags.sh

diff --git a/Makefile b/Makefile
index 0802acf352d2..6aa52276e969 100644
--- a/Makefile
+++ b/Makefile
@@ -480,6 +480,8 @@ LZ4		= lz4c
 XZ		= xz
 ZSTD		= zstd
 
+PAHOLE_FLAGS	= $(shell PAHOLE=$(PAHOLE) $(srctree)/scripts/pahole-flags.sh)
+
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void -Wno-unknown-attribute $(CF)
 NOSTDINC_FLAGS :=
@@ -534,6 +536,7 @@ export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
+export PAHOLE_FLAGS
 
 # Files to ignore in find ... statements
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index ff805777431c..ce9661d968a3 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -40,7 +40,7 @@ quiet_cmd_ld_ko_o = LD [M]  $@
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
-		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J $(PAHOLE_FLAGS) --btf_base vmlinux $@; \
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
 	fi;
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 3819a461465d..57ef6accbb40 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -211,7 +211,6 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
-	local extra_paholeopt=
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -226,16 +225,8 @@ gen_btf()
 
 	vmlinux_link ${1}
 
-	if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
-		# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
-		extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
-	fi
-	if [ "${pahole_ver}" -ge "121" ]; then
-		extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
-	fi
-
 	info "BTF" ${2}
-	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${extra_paholeopt} ${1}
+	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${PAHOLE_FLAGS} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
new file mode 100755
index 000000000000..e6093adf4c06
--- /dev/null
+++ b/scripts/pahole-flags.sh
@@ -0,0 +1,20 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+extra_paholeopt=
+
+if ! [ -x "$(command -v ${PAHOLE})" ]; then
+	exit 0
+fi
+
+pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+
+if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
+	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
+fi
+if [ "${pahole_ver}" -ge "121" ]; then
+	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
+fi
+
+echo ${extra_paholeopt}
-- 
2.37.2


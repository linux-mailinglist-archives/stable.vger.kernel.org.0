Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9508E24BE83
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgHTNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728122AbgHTJeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08E2F22B49;
        Thu, 20 Aug 2020 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916042;
        bh=K7VqwQrctBXFFVmyi6gy4VuQCsQ6TS3YyqT4D9EiO44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t++5L7udo45d+EjHghw0HjL3+kNc7ixFMYeRCJnCztxDcbaz6n1eMO74rfAE2N2ZG
         Pihr8qivWagfVUDTxpmqd08mnpaUD4Qx9lloa7W1uFphnAV5meXJXIooH5YBcxpaND
         zvQ6nJv8V2WGpo03+2TLC4u3NPKv0fW7rBc4qyeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 194/232] selftests/bpf: Fix silent Makefile output
Date:   Thu, 20 Aug 2020 11:20:45 +0200
Message-Id: <20200820091622.187340412@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit d5ca590525cfbd87ca307dcf498a566e2e7c1767 ]

99aacebecb75 ("selftests: do not use .ONESHELL") removed .ONESHELL, which
changes how Makefile "silences" multi-command target recipes. selftests/bpf's
Makefile relied (a somewhat unknowingly) on .ONESHELL behavior of silencing
all commands within the recipe if the first command contains @ symbol.
Removing .ONESHELL exposed this hack.

This patch fixes the issue by explicitly silencing each command with $(Q).

Also explicitly define fallback rule for building *.o from *.c, instead of
relying on non-silent inherited rule. This was causing a non-silent output for
bench.o object file.

Fixes: 92f7440ecc93 ("selftests/bpf: More succinct Makefile output")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200807033058.848677-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 44 +++++++++++++++-------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index dab182ffec320..4f322d5388757 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -102,7 +102,7 @@ endif
 OVERRIDE_TARGETS := 1
 override define CLEAN
 	$(call msg,CLEAN)
-	$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
+	$(Q)$(RM) -r $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) $(EXTRA_CLEAN)
 endef
 
 include ../lib.mk
@@ -122,17 +122,21 @@ $(notdir $(TEST_GEN_PROGS)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
+$(OUTPUT)/%.o: %.c
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+
 $(OUTPUT)/%:%.c
 	$(call msg,BINARY,,$@)
-	$(LINK.c) $^ $(LDLIBS) -o $@
+	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c
 	$(call msg,BINARY,,$@)
-	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
+	$(Q)$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
 
 $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
-	$(CC) -c $(CFLAGS) -o $@ $<
+	$(Q)$(CC) -c $(CFLAGS) -o $@ $<
 
 VMLINUX_BTF_PATHS := $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
@@ -180,11 +184,11 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 
 $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
 	$(call msg,MKDIR,,$@)
-	mkdir -p $@
+	$(Q)mkdir -p $@
 
 $(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
 	$(call msg,GEN,,$@)
-	$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -222,28 +226,28 @@ $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
 # $4 - LDFLAGS
 define CLANG_BPF_BUILD_RULE
 	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+	$(Q)($(CLANG) $3 -O2 -target bpf -emit-llvm			\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -mattr=dwarfris -march=bpf -mcpu=v3 $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
 define CLANG_NOALU32_BPF_BUILD_RULE
 	$(call msg,CLNG-LLC,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+	$(Q)($(CLANG) $3 -O2 -target bpf -emit-llvm			\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=v2 $4 -filetype=obj -o $2
 endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
 	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	($(CLANG) $3 -O2 -emit-llvm					\
+	$(Q)($(CLANG) $3 -O2 -emit-llvm					\
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=v3 $4 -filetype=obj -o $2
 endef
 # Build BPF object using GCC
 define GCC_BPF_BUILD_RULE
 	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
+	$(Q)$(BPF_GCC) $3 $4 -O2 -c $1 -o $2
 endef
 
 SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
@@ -285,7 +289,7 @@ ifeq ($($(TRUNNER_OUTPUT)-dir),)
 $(TRUNNER_OUTPUT)-dir := y
 $(TRUNNER_OUTPUT):
 	$$(call msg,MKDIR,,$$@)
-	mkdir -p $$@
+	$(Q)mkdir -p $$@
 endif
 
 # ensure we set up BPF objects generation rule just once for a given
@@ -305,7 +309,7 @@ $(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
 		      $(TRUNNER_OUTPUT)/%.o				\
 		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-	$$(BPFTOOL) gen skeleton $$< > $$@
+	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
 endif
 
 # ensure we set up tests.h header generation rule just once
@@ -329,7 +333,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
-	cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
+	$(Q)cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
 
 $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       %.c						\
@@ -337,20 +341,20 @@ $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		       $(TRUNNER_TESTS_HDR)				\
 		       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,EXT-OBJ,$(TRUNNER_BINARY),$$@)
-	$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
+	$(Q)$$(CC) $$(CFLAGS) -c $$< $$(LDLIBS) -o $$@
 
 # only copy extra resources if in flavored build
 $(TRUNNER_BINARY)-extras: $(TRUNNER_EXTRA_FILES) | $(TRUNNER_OUTPUT)
 ifneq ($2,)
 	$$(call msg,EXT-COPY,$(TRUNNER_BINARY),$(TRUNNER_EXTRA_FILES))
-	cp -a $$^ $(TRUNNER_OUTPUT)/
+	$(Q)cp -a $$^ $(TRUNNER_OUTPUT)/
 endif
 
 $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     $(TRUNNER_EXTRA_OBJS) $$(BPFOBJ)		\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
-	$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
+	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
 
 endef
 
@@ -403,17 +407,17 @@ verifier/tests.h: verifier/*.c
 		) > verifier/tests.h)
 $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
 	$(call msg,BINARY,,$@)
-	$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
-	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
+	$(Q)$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
 
 # Benchmark runner
 $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
 	$(call msg,CC,,$@)
-	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
 $(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
 $(OUTPUT)/bench_trigger.o: $(OUTPUT)/trigger_bench.skel.h
 $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
@@ -426,7 +430,7 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 		 $(OUTPUT)/bench_trigger.o \
 		 $(OUTPUT)/bench_ringbufs.o
 	$(call msg,BINARY,,$@)
-	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
+	$(Q)$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
 
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
-- 
2.25.1




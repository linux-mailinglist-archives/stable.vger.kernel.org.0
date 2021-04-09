Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD0359AC9
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhDIKDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232796AbhDIKBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39789611C0;
        Fri,  9 Apr 2021 09:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962374;
        bh=H+ucd1xCa5IfY91qGkFz/EZFvcRuxpgXHr0Ut3y1Upg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBTDuw/viqPVtvI2dLKca9aph8QSDBXYLTQeQnY9xHOQ55Y7YsL+u9AV4/LFcnBbX
         4PL8sfuqFobpR/tdI0LyPC5d8bmhxIdb2oGwWbDbB0F7Ww/womlZW5YFtHZV1OMd9x
         DierQm1XYZj7sxZz+TNRnErhydJV80lgAnoT1PmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/41] tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
Date:   Fri,  9 Apr 2021 11:53:54 +0200
Message-Id: <20210409095305.842617431@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit fc6b48f692f89cc48bfb7fd1aa65454dfe9b2d77 ]

Setting up separate build directories for libbpf and libpsubcmd,
so it's separated from other objects and we don't get them mixed
in the future.

It also simplifies cleaning, which is now simple rm -rf.

Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
files in .gitignore anymore.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210205124020.683286-2-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/.gitignore |  2 --
 tools/bpf/resolve_btfids/Makefile   | 26 +++++++++++---------------
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
index a026df7dc280..25f308c933cc 100644
--- a/tools/bpf/resolve_btfids/.gitignore
+++ b/tools/bpf/resolve_btfids/.gitignore
@@ -1,4 +1,2 @@
-/FEATURE-DUMP.libbpf
-/bpf_helper_defs.h
 /fixdep
 /resolve_btfids
diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
index bf656432ad73..1d46a247ec95 100644
--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -28,22 +28,22 @@ OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
 LIBBPF_SRC := $(srctree)/tools/lib/bpf/
 SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
 
-BPFOBJ     := $(OUTPUT)/libbpf.a
-SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
+BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
+SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
 
 BINARY     := $(OUTPUT)/resolve_btfids
 BINARY_IN  := $(BINARY)-in.o
 
 all: $(BINARY)
 
-$(OUTPUT):
+$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
 	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $(OUTPUT)
+	$(Q)mkdir -p $(@)
 
-$(SUBCMDOBJ): fixdep FORCE
-	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
+$(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
+	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
-$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
+$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
 
 CFLAGS := -g \
@@ -57,23 +57,19 @@ LIBS = -lelf -lz
 export srctree OUTPUT CFLAGS Q
 include $(srctree)/tools/build/Makefile.include
 
-$(BINARY_IN): fixdep FORCE
+$(BINARY_IN): fixdep FORCE | $(OUTPUT)
 	$(Q)$(MAKE) $(build)=resolve_btfids
 
 $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
 	$(call msg,LINK,$@)
 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
 
-libsubcmd-clean:
-	$(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
-
-libbpf-clean:
-	$(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
-
-clean: libsubcmd-clean libbpf-clean fixdep-clean
+clean: fixdep-clean
 	$(call msg,CLEAN,$(BINARY))
 	$(Q)$(RM) -f $(BINARY); \
 	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
+	$(RM) -rf $(OUTPUT)/libbpf; \
+	$(RM) -rf $(OUTPUT)/libsubcmd; \
 	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -name \*.o.d | xargs $(RM)
 
 tags:
-- 
2.30.2




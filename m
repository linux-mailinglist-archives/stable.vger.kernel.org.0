Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0D40927F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344576AbhIMOLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344643AbhIMOJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:09:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1020D61401;
        Mon, 13 Sep 2021 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540484;
        bh=IHiwLRHInZSslhpX8BF14mnsLnwcyohWknLxUKEV084=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7R79gbE12zaZXKI7jEWlWzHIAvMve0dbsa1QX5FHa7eOepl9Exb3H8WGaRF8Hg6F
         v+Cng9a08HxMHb5mOwrEmSA+EQzMD6aE0aBdQlQPMiNscXwb3/Wpe6lsyL34XYgyf3
         GayCo7atrOAehqWvrKbwSXUUnDV0L2T49OAJrEsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 195/300] libbpf: Re-build libbpf.so when libbpf.map changes
Date:   Mon, 13 Sep 2021 15:14:16 +0200
Message-Id: <20210913131115.965118923@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 61c7aa5020e98ac2fdcf07d07eec1baf2e9f0a08 ]

Ensure libbpf.so is re-built whenever libbpf.map is modified.  Without this,
changes to libbpf.map are not detected and versioned symbols mismatch error
will be reported until `make clean && make` is used, which is a suboptimal
developer experience.

Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210815070609.987780-8-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index e43e1896cb4b..0d9d8ed6512b 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -4,8 +4,9 @@
 RM ?= rm
 srctree = $(abs_srctree)
 
+VERSION_SCRIPT := libbpf.map
 LIBBPF_VERSION := $(shell \
-	grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
+	grep -oE '^LIBBPF_([0-9.]+)' $(VERSION_SCRIPT) | \
 	sort -rV | head -n1 | cut -d'_' -f2)
 LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
 
@@ -110,7 +111,6 @@ SHARED_OBJDIR	:= $(OUTPUT)sharedobjs/
 STATIC_OBJDIR	:= $(OUTPUT)staticobjs/
 BPF_IN_SHARED	:= $(SHARED_OBJDIR)libbpf-in.o
 BPF_IN_STATIC	:= $(STATIC_OBJDIR)libbpf-in.o
-VERSION_SCRIPT	:= libbpf.map
 BPF_HELPER_DEFS	:= $(OUTPUT)bpf_helper_defs.h
 
 LIB_TARGET	:= $(addprefix $(OUTPUT),$(LIB_TARGET))
@@ -163,10 +163,10 @@ $(BPF_HELPER_DEFS): $(srctree)/tools/include/uapi/linux/bpf.h
 
 $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
 
-$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED)
+$(OUTPUT)libbpf.so.$(LIBBPF_VERSION): $(BPF_IN_SHARED) $(VERSION_SCRIPT)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) \
 		--shared -Wl,-soname,libbpf.so.$(LIBBPF_MAJOR_VERSION) \
-		-Wl,--version-script=$(VERSION_SCRIPT) $^ -lelf -lz -o $@
+		-Wl,--version-script=$(VERSION_SCRIPT) $< -lelf -lz -o $@
 	@ln -sf $(@F) $(OUTPUT)libbpf.so
 	@ln -sf $(@F) $(OUTPUT)libbpf.so.$(LIBBPF_MAJOR_VERSION)
 
@@ -181,7 +181,7 @@ $(OUTPUT)libbpf.pc:
 
 check: check_abi
 
-check_abi: $(OUTPUT)libbpf.so
+check_abi: $(OUTPUT)libbpf.so $(VERSION_SCRIPT)
 	@if [ "$(GLOBAL_SYM_COUNT)" != "$(VERSIONED_SYM_COUNT)" ]; then	 \
 		echo "Warning: Num of global symbols in $(BPF_IN_SHARED)"	 \
 		     "($(GLOBAL_SYM_COUNT)) does NOT match with num of"	 \
-- 
2.30.2




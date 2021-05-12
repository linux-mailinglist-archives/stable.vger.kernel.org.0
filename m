Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB36237C9A8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbhELQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237350AbhELQOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5806761D45;
        Wed, 12 May 2021 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834136;
        bh=aBeg7Jjr1Uv0/Ho49u7aABcUJa16LArprl7itl8tNjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5mInij1izK5o0RUVAOy4t4f2Eky+RYouEX6QssXkTRPHn1F1wHbxLVxKmgvmzc4C
         cih/Vxu0AU49hsrB78ofr0XEyToeLDFmQoaUGAdpV5TNdzJ28BOtO2hMchDki0J2rX
         sxCdRLwUirrSyA6Qt4Mn4zPeNCC4fgk1i9zpT9M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 405/601] selftests/bpf: Re-generate vmlinux.h and BPF skeletons if bpftool changed
Date:   Wed, 12 May 2021 16:48:02 +0200
Message-Id: <20210512144841.156568950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit cab62c37be057379a2a17b1b2eacd9dcba1e14dc ]

Trigger vmlinux.h and BPF skeletons re-generation if detected that bpftool was
re-compiled. Otherwise full `make clean` is required to get updated skeletons,
if bpftool is modified.

Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210318194036.3521577-11-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c51df6b91bef..d47dd8a24a6f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -202,7 +202,7 @@ $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(BUILD_DIR)/resolve_btfids $(INCLUDE_D
 	$(call msg,MKDIR,,$@)
 	$(Q)mkdir -p $@
 
-$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
+$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
 ifeq ($(VMLINUX_H),)
 	$(call msg,GEN,,$@)
 	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
@@ -326,7 +326,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 
 $(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
 		      $(TRUNNER_OUTPUT)/%.o				\
-		      | $(BPFTOOL) $(TRUNNER_OUTPUT)
+		      $(BPFTOOL)					\
+		      | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
 	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
 endif
-- 
2.30.2




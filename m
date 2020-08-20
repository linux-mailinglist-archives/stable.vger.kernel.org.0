Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D489924BE4E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgHTNXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgHTJeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D781E208E4;
        Thu, 20 Aug 2020 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916034;
        bh=U+szTX/L2/s3tOi9Cau5a0/3kKmPmt+BJx8Y437yEqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+vCkMy+OxVNhzxeDDz2810SiG/M3QICzXJSmrs4OLb609gg5PxTcyAn4PhO3F6j+
         gNuOIDkIWYDppZ7l2gr8YkQHinHGSgwNRS8HKABToi4+gPf28ZO2XVOU4MkgZeFmj3
         fdMWX+6w2x5BRWa7CpL4iHL7JqODT57oEoQm6by8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 191/232] selftests/bpf: Prevent runqslower from racing on building bpftool
Date:   Thu, 20 Aug 2020 11:20:42 +0200
Message-Id: <20200820091622.043481957@linuxfoundation.org>
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

[ Upstream commit 6bcaf41f9613278cd5897fc80ab93033bda8efaa ]

runqslower's Makefile is building/installing bpftool into
$(OUTPUT)/sbin/bpftool, which coincides with $(DEFAULT_BPFTOOL). In practice
this means that often when building selftests from scratch (after `make
clean`), selftests are racing with runqslower to simultaneously build bpftool
and one of the two processes fail due to file being busy. Prevent this race by
explicitly order-depending on $(BPFTOOL_DEFAULT).

Fixes: a2c9652f751e ("selftests: Refactor build to remove tools/lib/bpf from include path")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200805004757.2960750-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 22aaec74ea0ab..dab182ffec320 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -141,7 +141,9 @@ VMLINUX_BTF_PATHS := $(if $(O),$(O)/vmlinux)				\
 		     /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF := $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
 
-$(OUTPUT)/runqslower: $(BPFOBJ)
+DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
+
+$(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
 		    OUTPUT=$(SCRATCH_DIR)/ VMLINUX_BTF=$(VMLINUX_BTF)   \
 		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&	\
@@ -163,7 +165,6 @@ $(OUTPUT)/test_netcnt: cgroup_helpers.c
 $(OUTPUT)/test_sock_fields: cgroup_helpers.c
 $(OUTPUT)/test_sysctl: cgroup_helpers.c
 
-DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
-- 
2.25.1




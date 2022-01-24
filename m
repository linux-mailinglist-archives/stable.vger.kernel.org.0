Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A940549929E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355383AbiAXUWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:22:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381365AbiAXUUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EEAFB811F9;
        Mon, 24 Jan 2022 20:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA9CC340E5;
        Mon, 24 Jan 2022 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055611;
        bh=+EXpyvKm32xvisiAq/RoY1t3Z2SWkpE51+f4s4DEdBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtdEZ3NfjrJ8/cr8YTELHbyxhzrhuhbqx9A0/ezIQ9ijRwfliSNCdIit4BtgIASQT
         gKkUBdipfJQMt3/l6iqn9PGtS7rWOU8R5oRnFl6l1x07LI+tLhFYF9uW17Ua89wllH
         AHOCyz+CWnl5Qp1CB1OHvNoMs3HA3zJ+es+QPzXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/846] samples/bpf: Clean up samples/bpf build failes
Date:   Mon, 24 Jan 2022 19:35:24 +0100
Message-Id: <20220124184108.062857358@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 527024f7aeb683ce7ef49b07ef7ce9ecf015288d ]

Remove xdp_samples_user.o rule redefinition which generates Makefile
warning and instead override TPROGS_CFLAGS. This seems to work fine when
building inside selftests/bpf.

That was one big head-scratcher before I found that generic
Makefile.target hid this surprising specialization for for xdp_samples_user.o.

Main change is to use actual locally installed libbpf headers.

Also drop printk macro re-definition (not even used!).

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211201232824.3166325-8-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile            | 13 ++++++++++++-
 samples/bpf/Makefile.target     | 11 -----------
 samples/bpf/hbm_kern.h          |  2 --
 samples/bpf/lwt_len_hist_kern.c |  7 -------
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 01993b502f6a4..8ac8573946e1a 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -325,7 +325,7 @@ $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
 libbpf_hdrs: $(LIBBPF)
-$(obj)/$(TRACE_HELPERS): | libbpf_hdrs
+$(obj)/$(TRACE_HELPERS) $(obj)/$(CGROUP_HELPERS) $(obj)/$(XDP_SAMPLE): | libbpf_hdrs
 
 .PHONY: libbpf_hdrs
 
@@ -340,6 +340,17 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+# Override includes for xdp_sample_user.o because $(srctree)/usr/include in
+# TPROGS_CFLAGS causes conflicts
+XDP_SAMPLE_CFLAGS += -Wall -O2 -lm \
+		     -I$(src)/../../tools/include \
+		     -I$(src)/../../tools/include/uapi \
+		     -I$(LIBBPF_INCLUDE) \
+		     -I$(src)/../../tools/testing/selftests/bpf
+
+$(obj)/$(XDP_SAMPLE): TPROGS_CFLAGS = $(XDP_SAMPLE_CFLAGS)
+$(obj)/$(XDP_SAMPLE): $(src)/xdp_sample_user.h $(src)/xdp_sample_shared.h
+
 -include $(BPF_SAMPLES_PATH)/Makefile.target
 
 VMLINUX_BTF_PATHS ?= $(abspath $(if $(O),$(O)/vmlinux))				\
diff --git a/samples/bpf/Makefile.target b/samples/bpf/Makefile.target
index 5a368affa0386..7621f55e2947d 100644
--- a/samples/bpf/Makefile.target
+++ b/samples/bpf/Makefile.target
@@ -73,14 +73,3 @@ quiet_cmd_tprog-cobjs	= CC  $@
       cmd_tprog-cobjs	= $(CC) $(tprogc_flags) -c -o $@ $<
 $(tprog-cobjs): $(obj)/%.o: $(src)/%.c FORCE
 	$(call if_changed_dep,tprog-cobjs)
-
-# Override includes for xdp_sample_user.o because $(srctree)/usr/include in
-# TPROGS_CFLAGS causes conflicts
-XDP_SAMPLE_CFLAGS += -Wall -O2 -lm \
-		     -I./tools/include \
-		     -I./tools/include/uapi \
-		     -I./tools/lib \
-		     -I./tools/testing/selftests/bpf
-$(obj)/xdp_sample_user.o: $(src)/xdp_sample_user.c \
-	$(src)/xdp_sample_user.h $(src)/xdp_sample_shared.h
-	$(CC) $(XDP_SAMPLE_CFLAGS) -c -o $@ $<
diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index 722b3fadb4675..1752a46a2b056 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -9,8 +9,6 @@
  * Include file for sample Host Bandwidth Manager (HBM) BPF programs
  */
 #define KBUILD_MODNAME "foo"
-#include <stddef.h>
-#include <stdbool.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/if_packet.h>
diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_kern.c
index 9ed63e10e1709..1fa14c54963a1 100644
--- a/samples/bpf/lwt_len_hist_kern.c
+++ b/samples/bpf/lwt_len_hist_kern.c
@@ -16,13 +16,6 @@
 #include <uapi/linux/in.h>
 #include <bpf/bpf_helpers.h>
 
-# define printk(fmt, ...)						\
-		({							\
-			char ____fmt[] = fmt;				\
-			bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				     ##__VA_ARGS__);			\
-		})
-
 struct bpf_elf_map {
 	__u32 type;
 	__u32 size_key;
-- 
2.34.1




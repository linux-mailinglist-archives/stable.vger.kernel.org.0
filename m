Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB3499A13
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456677AbiAXVjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453938AbiAXVbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E04C075940;
        Mon, 24 Jan 2022 12:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A3A61008;
        Mon, 24 Jan 2022 20:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736C6C340E5;
        Mon, 24 Jan 2022 20:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055614;
        bh=KAEEPgoOeOikhj6Qcspk7moZQGuTJ0URGvqWMGvh9Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koa87U8T01VeHqKcOIG3w9lLgafXAsRp/Rzd/kdohrSQG3sMUuWjMJH75nl8HEWDj
         DxR2/XPG1SujImRdv1J+mbcIhRhFZIiCWAbqirv4YiUcH8n/v23TD9XbZPFo8RhyGZ
         MiUMungEF4gugEtTy1mZl3HnjVllh9L6esw87Og8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/846] samples: bpf: Fix xdp_sample_user.o linking with Clang
Date:   Mon, 24 Jan 2022 19:35:25 +0100
Message-Id: <20220124184108.099853358@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit e64fbcaa7a666f16329b1c67af15ea501bc84586 ]

Clang (13) doesn't get the jokes about specifying libraries to link in
cclags of individual .o objects:

clang-13: warning: -lm: 'linker' input unused [-Wunused-command-line-argument]
[ ... ]
  LD  samples/bpf/xdp_redirect_cpu
  LD  samples/bpf/xdp_redirect_map_multi
  LD  samples/bpf/xdp_redirect_map
  LD  samples/bpf/xdp_redirect
  LD  samples/bpf/xdp_monitor
/usr/bin/ld: samples/bpf/xdp_sample_user.o: in function `sample_summary_print':
xdp_sample_user.c:(.text+0x84c): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x870): undefined reference to `ceil'
/usr/bin/ld: xdp_sample_user.c:(.text+0x8cf): undefined reference to `floor'
/usr/bin/ld: xdp_sample_user.c:(.text+0x8f3): undefined reference to `ceil'
[ more ]

Specify '-lm' as ldflags for all xdp_sample_user.o users in the main
Makefile and remove it from ccflags of ^ in Makefile.target -- just
like it's done for all other samples. This works with all compilers.

Fixes: 6e1051a54e31 ("samples: bpf: Convert xdp_monitor to XDP samples helper")
Fixes: b926c55d856c ("samples: bpf: Convert xdp_redirect to XDP samples helper")
Fixes: e531a220cc59 ("samples: bpf: Convert xdp_redirect_cpu to XDP samples helper")
Fixes: bbe65865aa05 ("samples: bpf: Convert xdp_redirect_map to XDP samples helper")
Fixes: 594a116b2aa1 ("samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20211203195004.5803-2-alexandr.lobakin@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8ac8573946e1a..c6e38e43c3fd0 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -213,6 +213,11 @@ TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
 endif
 
 TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
+TPROGLDLIBS_xdp_monitor		+= -lm
+TPROGLDLIBS_xdp_redirect	+= -lm
+TPROGLDLIBS_xdp_redirect_cpu	+= -lm
+TPROGLDLIBS_xdp_redirect_map	+= -lm
+TPROGLDLIBS_xdp_redirect_map_multi += -lm
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
@@ -342,7 +347,7 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
-XDP_SAMPLE_CFLAGS += -Wall -O2 -lm \
+XDP_SAMPLE_CFLAGS += -Wall -O2 \
 		     -I$(src)/../../tools/include \
 		     -I$(src)/../../tools/include/uapi \
 		     -I$(LIBBPF_INCLUDE) \
-- 
2.34.1




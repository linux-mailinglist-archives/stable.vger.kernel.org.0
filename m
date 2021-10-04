Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69514420FD7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhJDNjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237396AbhJDNhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B581961371;
        Mon,  4 Oct 2021 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353408;
        bh=ICQ9giKx1yX1KNC8hrc8Dh7/P4Nbzd8yq/uN1thGmYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upP7ctRV2UgT/psxmJF3oS97ki7Z94sppTXoLvIePzIZjE0q+rE0ywsNov2R9cRgt
         XshK6O/vrc52n7/jRST3zF9kJ1s8TAWuaQovxm77H59olPnyH3Q1D8lBEXH70Rq2+X
         gxnghF8LDmB4zisA4sn983OZn0HTS9U9jZM4zKPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 116/172] selftests, bpf: Fix makefile dependencies on libbpf
Date:   Mon,  4 Oct 2021 14:52:46 +0200
Message-Id: <20211004125048.730812023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit d888eaac4fb1df30320bb1305a8f78efe86524c6 ]

When building bpf selftest with make -j, I'm randomly getting build failures
such as this one:

  In file included from progs/bpf_flow.c:19:
  [...]/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h' file not found
  #include "bpf_helper_defs.h"
           ^~~~~~~~~~~~~~~~~~~

The file that fails the build varies between runs but it's always in the
progs/ subdir.

The reason is a missing make dependency on libbpf for the .o files in
progs/. There was a dependency before commit 3ac2e20fba07e but that commit
removed it to prevent unneeded rebuilds. However, that only works if libbpf
has been built already; the 'wildcard' prerequisite does not trigger when
there's no bpf_helper_defs.h generated yet.

Keep the libbpf as an order-only prerequisite to satisfy both goals. It is
always built before the progs/ objects but it does not trigger unnecessary
rebuilds by itself.

Fixes: 3ac2e20fba07e ("selftests/bpf: BPF object files should depend only on libbpf headers")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/ee84ab66436fba05a197f952af23c98d90eb6243.1632758415.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f405b20c1e6c..93f1f124ef89 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -374,7 +374,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
 		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
 		     $$(INCLUDE_DIR)/vmlinux.h				\
-		     $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)
+		     $(wildcard $(BPFDIR)/bpf_*.h)			\
+		     | $(TRUNNER_OUTPUT) $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS))
 
-- 
2.33.0




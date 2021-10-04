Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8943E420E68
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhJDNZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236825AbhJDNXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0B861B5E;
        Mon,  4 Oct 2021 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353004;
        bh=7E488kNvT1zaO4pNEysm4W6y/Uu7fAPKtFi2PsRU+jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=woP7FbI/IS5QnxAJDIcMS4CEKSknfgGTEeD70GVP75p6R64wDNmJSuE3JTpQcyqkx
         3wgAAV+Yr1Sd7xI8C3QFIyc7a+Zc2Q6tvNhZMTbRCYvhw/UNwreCJ50OfxfSaydrMb
         o3blvpZ2Bxbsp97A23IV9WPTiZs90dH61Pgevxdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/93] selftests, bpf: Fix makefile dependencies on libbpf
Date:   Mon,  4 Oct 2021 14:52:48 +0200
Message-Id: <20211004125036.230449813@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
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
index b5322d60068c..1d9155533360 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -326,7 +326,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
 		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
 		     $$(INCLUDE_DIR)/vmlinux.h				\
-		     $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)
+		     $(wildcard $(BPFDIR)/bpf_*.h)			\
+		     | $(TRUNNER_OUTPUT) $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS),	\
 					  $(TRUNNER_BPF_LDFLAGS))
-- 
2.33.0




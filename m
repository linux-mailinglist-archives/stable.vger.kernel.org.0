Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4ED3ED660
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbhHPNUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240064AbhHPNQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90669632EA;
        Mon, 16 Aug 2021 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119617;
        bh=OzHKg4XQQx2eDs/B6xuKl4iDNgcJ+RPtAHzgsKZuWQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uq1iMFAINx9nWhwFqqYF2dzQsxj/1hE9hGr3+RcdLFxlhoGfnqjgkvTeXyoMsJvn7
         RO7elg7140Kt2MGRYEOUR5w+3SoByLdTN6vfZw5Z3jjKGDJGihwtidFj5ZfO77Ubnf
         Q44BxDgOGfr4VXoupj7uT5GKO0bpTAjCKuViEwEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Robin=20G=C3=B6gge?= <r.goegge@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 062/151] libbpf: Fix probe for BPF_PROG_TYPE_CGROUP_SOCKOPT
Date:   Mon, 16 Aug 2021 15:01:32 +0200
Message-Id: <20210816125446.103028913@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Gögge <r.goegge@googlemail.com>

[ Upstream commit 78d14bda861dd2729f15bb438fe355b48514bfe0 ]

This patch fixes the probe for BPF_PROG_TYPE_CGROUP_SOCKOPT,
so the probe reports accurate results when used by e.g.
bpftool.

Fixes: 4cdbfb59c44a ("libbpf: support sockopt hooks")
Signed-off-by: Robin Gögge <r.goegge@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20210728225825.2357586-1-r.goegge@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf_probes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index ecaae2927ab8..cd8c703dde71 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -75,6 +75,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 		xattr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
 		break;
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+		xattr.expected_attach_type = BPF_CGROUP_GETSOCKOPT;
+		break;
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		xattr.expected_attach_type = BPF_SK_LOOKUP;
 		break;
@@ -104,7 +107,6 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
-	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_TRACING:
 	case BPF_PROG_TYPE_STRUCT_OPS:
 	case BPF_PROG_TYPE_EXT:
-- 
2.30.2




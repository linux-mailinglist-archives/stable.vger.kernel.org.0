Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CBA12C7C0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfL2RqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbfL2RqF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B885207FF;
        Sun, 29 Dec 2019 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641564;
        bh=1xcMMT3Xv6K8NqYsrKf0WvTs26fBGJW1QID2H940DkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP+xUQxKLJuMAnPACK9o6ZVXckzoSXlQ5yBjK0yL18/DDxC3RQd0WIdjw6MUSe/Qo
         IRQI1vk15H7mhSWGO1SXVswGusbTeCj5cEeYxuxgkTem0bnobaVhoXj7g4n5lG9Yba
         MtigMidCcG+iAUw+jf8dyPTt/zKZgIgK99VViyhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/434] libbpf: Fix passing uninitialized bytes to setsockopt
Date:   Sun, 29 Dec 2019 18:22:52 +0100
Message-Id: <20191229172709.591629300@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 25bfef430e960e695403b5d9c8dcc11b9f5d62be ]

'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
valgrind complain about passing uninitialized stack memory to the
syscall:

  Syscall param socketcall.setsockopt() points to uninitialised byte(s)
    at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
    by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
  Uninitialised value was created by a stack allocation
    at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)

Padding bytes appeared after introducing of a new 'flags' field.
memset() is required to clear them.

Fixes: 10d30e301732 ("libbpf: add flags to umem config")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20191009164929.17242-1-i.maximets@ovn.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index a902838f9fcc..9d5348086203 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -163,6 +163,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
 	umem->umem_area = umem_area;
 	xsk_set_umem_config(&umem->config, usr_config);
 
+	memset(&mr, 0, sizeof(mr));
 	mr.addr = (uintptr_t)umem_area;
 	mr.len = size;
 	mr.chunk_size = umem->config.frame_size;
-- 
2.20.1




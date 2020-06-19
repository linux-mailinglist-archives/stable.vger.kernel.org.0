Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F232B2011A9
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394048AbgFSPmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393579AbgFSP2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 783442186A;
        Fri, 19 Jun 2020 15:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580511;
        bh=NxAJsTGELpCsWIQyrpwGz1O0iqdSozOGgaX3qe3alLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odg/lCIhUe5L5CLumN7w/4ZsN4mSBc0wHUbTJ+ozrb95D2j904b5PDQW1zNcHpApB
         O4UVMx5W/AADhNIhAfxjlBQyO6quocDI1jXcO7O04MoSr5pE9ZMwe6tIt+ZT7ttD6W
         MdaEFQpmiduYxqduufRpFgoox6gdtZxfkFRig/KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 247/376] libbpf: Fix perf_buffer__free() API for sparse allocs
Date:   Fri, 19 Jun 2020 16:32:45 +0200
Message-Id: <20200619141722.017192577@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 601b05ca6edb0422bf6ce313fbfd55ec7bbbc0fd ]

In case the cpu_bufs are sparsely allocated they are not all
free'ed. These changes will fix this.

Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159056888305.330763.9684536967379110349.stgit@ebuild
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cd53204d33f0..0c5b4fb553fb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7809,9 +7809,12 @@ void perf_buffer__free(struct perf_buffer *pb)
 	if (!pb)
 		return;
 	if (pb->cpu_bufs) {
-		for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
+		for (i = 0; i < pb->cpu_cnt; i++) {
 			struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
 
+			if (!cpu_buf)
+				continue;
+
 			bpf_map_delete_elem(pb->map_fd, &cpu_buf->map_key);
 			perf_buffer__free_cpu_buf(pb, cpu_buf);
 		}
-- 
2.25.1




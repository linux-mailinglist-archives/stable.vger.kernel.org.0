Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C422B6491
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbgKQNsA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:48:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731486AbgKQNhB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D99C20780;
        Tue, 17 Nov 2020 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620221;
        bh=4xuzPg0kOjxj2nNV9bckmdhedAE/3CqJSwUrZfjd9fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4FyxoE4DZq0DozJGGvB/vT/LHxz3OYH30KnLkfIUGBK4sW+KJJtQE73KFFgQ6lLr
         oA8Uqr2diGaQQLUILAu989vLGNXjzCaO796VjAemTeE1XQXXR8Y4OP5WokO9NBuSBR
         zgEMzw7IOARYTjqizXJBW0SBXq3BsT7NljDt/Ec4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 146/255] tools/bpftool: Fix attaching flow dissector
Date:   Tue, 17 Nov 2020 14:04:46 +0100
Message-Id: <20201117122146.068682284@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit f9b7ff0d7f7a466a920424246e7ddc2b84c87e52 ]

My earlier patch to reject non-zero arguments to flow dissector attach
broke attaching via bpftool. Instead of 0 it uses -1 for target_fd.
Fix this by passing a zero argument when attaching the flow dissector.

Fixes: 1b514239e859 ("bpf: flow_dissector: Check value of unused flags to BPF_PROG_ATTACH")
Reported-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20201105115230.296657-1-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index d393eb8263a60..994506540e564 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -741,7 +741,7 @@ static int parse_attach_detach_args(int argc, char **argv, int *progfd,
 	}
 
 	if (*attach_type == BPF_FLOW_DISSECTOR) {
-		*mapfd = -1;
+		*mapfd = 0;
 		return 0;
 	}
 
-- 
2.27.0




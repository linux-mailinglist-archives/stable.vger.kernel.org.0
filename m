Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6999B2012AA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392515AbgFSPyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392908AbgFSPVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E10921548;
        Fri, 19 Jun 2020 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580108;
        bh=gxk9MSh3P8MPirDz3R+VvLbXVPW8bi0sEi+cQ9ZIbSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZNH6S3oUw694ObXR95Yvck4TjKqPp27gcyO8xaMDvIB/wqz5Rpt1vHl4ollK+VB4
         5nRTaDJ3M2YdTI9zvwkA7oLdfUrJFJsPbSZAEAbgsn0UaNp6n94dz/5N0JeCxGuskD
         bGoLu7F6Uc29VI24oUauUMJZMlnr1wjVt+BDR5dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Carlos Neira <cneirabustos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 126/376] selftests/bpf: Fix bpf_link leak in ns_current_pid_tgid selftest
Date:   Fri, 19 Jun 2020 16:30:44 +0200
Message-Id: <20200619141716.299527080@linuxfoundation.org>
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

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 8d30e80a049ad699264e4a12911e349f93c7279a ]

If condition is inverted, but it's also just not necessary.

Fixes: 1c1052e0140a ("tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Carlos Neira <cneirabustos@gmail.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-11-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 542240e16564..e74dc501b27f 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -80,9 +80,6 @@ void test_ns_current_pid_tgid(void)
 		  "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
 		goto cleanup;
 cleanup:
-	if (!link) {
-		bpf_link__destroy(link);
-		link = NULL;
-	}
+	bpf_link__destroy(link);
 	bpf_object__close(obj);
 }
-- 
2.25.1




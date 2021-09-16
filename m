Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78AF40E840
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353446AbhIPRoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354955AbhIPRkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397A9601FC;
        Thu, 16 Sep 2021 16:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811097;
        bh=RgyEE/gxv2+PbwT+Twl7+jMwQK+Cn83YUGhdVMiZbVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUzGSSE/yUL1fPYbgmTA8igMEud3xaMMmME7TBpQu/pD+A+nYYQ3hY/OTL/NPfAZv
         DBY/yc/iPRIBGtVjEnvWApyo+JaYIZ8A72rtFwbAzof4OC3SLelEbc1H+ItENn35wK
         Pon+4gnk63sXBvL5POvfCCj9CIKgmJnpRDtLtjaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 383/432] selftests/bpf: Fix potential unreleased lock
Date:   Thu, 16 Sep 2021 18:02:12 +0200
Message-Id: <20210916155823.791803824@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit 47bb27a20d6ea22cd092c1fc2bb4fcecac374838 ]

This lock is not released if the program
return at the patched branch.

Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210827074140.118671-1-cyeaa@connect.ust.hk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
index ec281b0363b8..86f97681ad89 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
@@ -195,8 +195,10 @@ static void run_test(int cgroup_fd)
 
 	pthread_mutex_lock(&server_started_mtx);
 	if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
-				      (void *)&server_fd)))
+				      (void *)&server_fd))) {
+		pthread_mutex_unlock(&server_started_mtx);
 		goto close_server_fd;
+	}
 	pthread_cond_wait(&server_started, &server_started_mtx);
 	pthread_mutex_unlock(&server_started_mtx);
 
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB974690B
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfFNUaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfFNUaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:10 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78C222184C;
        Fri, 14 Jun 2019 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544209;
        bh=eAsMLk2fEpyKxTf8PkrwhRvO+6PMw7w9PlfyCtWB2fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODyTBqJnaKiGm8GGFSYT056OYVQNHB/m7Zm1VqRHKMH436DE29FuWu5UEsABEGy/k
         JaADTETq8heUvw+rG38NEVLFfYWsUD4hVMmPeegyw6AvUF3kzte+bFupi0ajnvy5VZ
         FQxQLtjaG0/GNH49gAKBI8Umsie6QwY+TUWawyBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>, Claudio Zumbo <claudioz@fb.com>,
        Claudio <claudiozumbo@gmail.com>,
        linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 19/39] kselftest/cgroup: fix incorrect test_core skip
Date:   Fri, 14 Jun 2019 16:29:24 -0400
Message-Id: <20190614202946.27385-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit f97f3f8839eb9de5843066d80819884f7722c8c5 ]

The test_core will skip the
test_cgcore_no_internal_process_constraint_on_threads test case if the
'cpu' controller missing in root's subtree_control. In fact we need to
set the 'cpu' in subtree_control, to make the testing meaningful.

./test_core
...
ok 4 # skip test_cgcore_no_internal_process_constraint_on_threads
...

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Claudio Zumbo <claudioz@fb.com>
Cc: Claudio <claudiozumbo@gmail.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index d78f1c5366d3..79053a4f4783 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -198,7 +198,7 @@ static int test_cgcore_no_internal_process_constraint_on_threads(const char *roo
 	char *parent = NULL, *child = NULL;
 
 	if (cg_read_strstr(root, "cgroup.controllers", "cpu") ||
-	    cg_read_strstr(root, "cgroup.subtree_control", "cpu")) {
+	    cg_write(root, "cgroup.subtree_control", "+cpu")) {
 		ret = KSFT_SKIP;
 		goto cleanup;
 	}
-- 
2.20.1


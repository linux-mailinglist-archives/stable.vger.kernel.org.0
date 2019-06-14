Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD146A36
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfFNU3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbfFNU3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:08 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1390217F9;
        Fri, 14 Jun 2019 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544147;
        bh=fBomxnnpTQhou0FHVuASFGMxuW+Dxcx9mP4d2DjZGAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spyPYdM0af+Stnh/IP9R0F5n/3pTdXld2VEvXFrwpit1HUJZW0mIS8cpdWSz1bdmo
         Zq8khSqpGzjCFtwm3+BOgTlO+0nNM0GFuI4W67jKOyz/M1GUzxOxY+Pc4fvTVVALZH
         lBWfCXQ8pKb6LLmo0usQV4HreveioAnL6Z0iHWPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Shi <alex.shi@linux.alibaba.com>,
        Shuah Khan <shuah@kernel.org>, Roman Gushchin <guro@fb.com>,
        Tejun Heo <tj@kernel.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Jay Kamat <jgkamat@fb.com>, linux-kselftest@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 28/59] kselftest/cgroup: fix unexpected testing failure on test_memcontrol
Date:   Fri, 14 Jun 2019 16:28:12 -0400
Message-Id: <20190614202843.26941-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit f6131f28057d4fd8922599339e701a2504e0f23d ]

The cgroup testing relies on the root cgroup's subtree_control setting,
If the 'memory' controller isn't set, all test cases will be failed
as following:

$ sudo ./test_memcontrol
not ok 1 test_memcg_subtree_control
not ok 2 test_memcg_current
ok 3 # skip test_memcg_min
not ok 4 test_memcg_low
not ok 5 test_memcg_high
not ok 6 test_memcg_max
not ok 7 test_memcg_oom_events
ok 8 # skip test_memcg_swap_max
not ok 9 test_memcg_sock
not ok 10 test_memcg_oom_group_leaf_events
not ok 11 test_memcg_oom_group_parent_events
not ok 12 test_memcg_oom_group_score_events

To correct this unexpected failure, this patch write the 'memory' to
subtree_control of root to get a right result.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Jay Kamat <jgkamat@fb.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 6f339882a6ca..c19a97dd02d4 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1205,6 +1205,10 @@ int main(int argc, char **argv)
 	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
 		ksft_exit_skip("memory controller isn't available\n");
 
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
-- 
2.20.1


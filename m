Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8163F603D51
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiJSJAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiJSI7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A039CDFC0;
        Wed, 19 Oct 2022 01:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E279617E1;
        Wed, 19 Oct 2022 08:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC2EC433C1;
        Wed, 19 Oct 2022 08:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169557;
        bh=++xZ9cOrQDr9pnFr2qPK44wCfNxJfYGFxx6qpI+u2Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZ15T5a/7g6kcEI7OygVObqOFcP+h56euIyFzMkkHDD2NIBUUopPfvCiPZREjGd1c
         d7jRqn5Fva6EOvNEfzUMwCshFSFeAbhzlqKvzub+EJ4xDas115+oOrB02hxWF4v10K
         MFfk+hrPE12yqRMdvUEf3OAm0H704wAnT09EyOJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pu Lehui <pulehui@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 304/862] selftests/bpf: Adapt cgroup effective query uapi change
Date:   Wed, 19 Oct 2022 10:26:31 +0200
Message-Id: <20221019083303.438903129@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit d2aa993b7d9de6deeb1df6c9a6b9b6193c337cc6 ]

The attach flags is meaningless for effective query and
its value will always be set as 0 during effective query.
Root cg's effective progs is always its attached progs,
so we use non-effective query to get its progs count and
attach flags. And we don't need the remain attach flags
check.

Fixes: b79c9fc9551b ("bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20220921104604.2340580-4-pulehui@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/cgroup_link.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
index 9e6e6aad347c..15093a69510e 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -71,10 +71,9 @@ void serial_test_cgroup_link(void)
 
 	ping_and_check(cg_nr, 0);
 
-	/* query the number of effective progs and attach flags in root cg */
+	/* query the number of attached progs and attach flags in root cg */
 	err = bpf_prog_query(cgs[0].fd, BPF_CGROUP_INET_EGRESS,
-			     BPF_F_QUERY_EFFECTIVE, &attach_flags, NULL,
-			     &prog_cnt);
+			     0, &attach_flags, NULL, &prog_cnt);
 	CHECK_FAIL(err);
 	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
 	if (CHECK(prog_cnt != 1, "effect_cnt", "exp %d, got %d\n", 1, prog_cnt))
@@ -85,17 +84,15 @@ void serial_test_cgroup_link(void)
 			     BPF_F_QUERY_EFFECTIVE, NULL, NULL,
 			     &prog_cnt);
 	CHECK_FAIL(err);
-	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
 	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
 		  cg_nr, prog_cnt))
 		goto cleanup;
 
 	/* query the effective prog IDs in last cg */
 	err = bpf_prog_query(cgs[last_cg].fd, BPF_CGROUP_INET_EGRESS,
-			     BPF_F_QUERY_EFFECTIVE, &attach_flags,
-			     prog_ids, &prog_cnt);
+			     BPF_F_QUERY_EFFECTIVE, NULL, prog_ids,
+			     &prog_cnt);
 	CHECK_FAIL(err);
-	CHECK_FAIL(attach_flags != BPF_F_ALLOW_MULTI);
 	if (CHECK(prog_cnt != cg_nr, "effect_cnt", "exp %d, got %d\n",
 		  cg_nr, prog_cnt))
 		goto cleanup;
-- 
2.35.1




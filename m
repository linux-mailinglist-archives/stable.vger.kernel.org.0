Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFA24F36F7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240702AbiDELJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348817AbiDEJsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFC0AC938;
        Tue,  5 Apr 2022 02:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D22BB81B75;
        Tue,  5 Apr 2022 09:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923A9C385A0;
        Tue,  5 Apr 2022 09:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151368;
        bh=K6geJeEW5QaOD+aLW/HKf6IJ3et2Chj97ahJ/fcGf9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDuPES/2QE5aL6JRMbKTCG28nac+T6vQmZ/Z/ye4VvB/gjb2+JK16kg53k9Bu29dr
         DphVKwG4SvBeuS68qiBlkMQ3JBU1Q8AyGRfq8kOlAEQ2Y6g+f8PKxyUup042OEYTSo
         P5vUb+Uip+CQSq75LK7GJ5BFbIG6l8uii+2U2H88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Maurer <fmaurer@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/913] selftests: bpf: Fix bind on used port
Date:   Tue,  5 Apr 2022 09:24:12 +0200
Message-Id: <20220405070351.537975626@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Maurer <fmaurer@redhat.com>

[ Upstream commit 8c0be0631d81e48f77d0ebf0534c86e32bef5f89 ]

The bind_perm BPF selftest failed when port 111/tcp was already in use
during the test. To fix this, the test now runs in its own network name
space.

To use unshare, it is necessary to reorder the includes. The style of
the includes is adapted to be consistent with the other prog_tests.

v2: Replace deprecated CHECK macro with ASSERT_OK

Fixes: 8259fdeb30326 ("selftests/bpf: Verify that rebinding to port < 1024 from BPF works")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/551ee65533bb987a43f93d88eaf2368b416ccd32.1642518457.git.fmaurer@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/bind_perm.c      | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
index d0f06e40c16d..eac71fbb24ce 100644
--- a/tools/testing/selftests/bpf/prog_tests/bind_perm.c
+++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
@@ -1,13 +1,24 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <test_progs.h>
-#include "bind_perm.skel.h"
-
+#define _GNU_SOURCE
+#include <sched.h>
+#include <stdlib.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/capability.h>
 
+#include "test_progs.h"
+#include "bind_perm.skel.h"
+
 static int duration;
 
+static int create_netns(void)
+{
+	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
+		return -1;
+
+	return 0;
+}
+
 void try_bind(int family, int port, int expected_errno)
 {
 	struct sockaddr_storage addr = {};
@@ -75,6 +86,9 @@ void test_bind_perm(void)
 	struct bind_perm *skel;
 	int cgroup_fd;
 
+	if (create_netns())
+		return;
+
 	cgroup_fd = test__join_cgroup("/bind_perm");
 	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
 		return;
-- 
2.34.1




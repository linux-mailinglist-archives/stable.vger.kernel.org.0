Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6462A4F2A84
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiDEJ3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiDEIxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDDEC7B;
        Tue,  5 Apr 2022 01:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1CE1CE1C6B;
        Tue,  5 Apr 2022 08:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ECCC385A1;
        Tue,  5 Apr 2022 08:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148606;
        bh=K6geJeEW5QaOD+aLW/HKf6IJ3et2Chj97ahJ/fcGf9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOsDdubPSESNbpJST1vNH8qe1LiYVQ0344dbse6Tz/vwzWaFF0N7BSV3CK4Q1AoR/
         CYddz58WgQAVYmdJxHpGNk5oHyolwfTxk453z+uQBiuEMh0yymYy3ihnyL1ZtIUHMj
         BvVTnSRW28cx1wOsAo1H8iSyNiCnmtPkox0hqcuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Maurer <fmaurer@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0415/1017] selftests: bpf: Fix bind on used port
Date:   Tue,  5 Apr 2022 09:22:08 +0200
Message-Id: <20220405070406.607807821@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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




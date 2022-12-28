Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D139657DA3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiL1PpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiL1PpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:45:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C039E175B8
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:45:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74DEBB81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2258C433D2;
        Wed, 28 Dec 2022 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242315;
        bh=9S+nyIw6bNeVT5PxsfGFyVis2ssnl8zcLQld/VqatFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2hDa4l9rnQtreSE9MSxnBp0gguit+hj9n/mBjaC+mtDsTed6wDs4iiCu6PWTne1U
         +m5bxfKagHhp5VMDAIFt828Nia2HafSw2pHewQnB4QS3pOoakgMXvwDdYcAmuPriIC
         UxWmVWlU1lETGt92oBWGoyQ8wFBw+xXKweUMuXGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>, Yonghong Song <yhs@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0327/1146] selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
Date:   Wed, 28 Dec 2022 15:31:06 +0100
Message-Id: <20221228144339.041115023@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 52929912d7bda040b43538e8d88e8d231b76eb4e ]

This patch fixes the incorrect ASSERT test in tcp_hdr_options during
the CHECK to ASSERT macro cleanup.

Fixes: 3082f8cd4ba3 ("selftests/bpf: Convert tcp_hdr_options test to ASSERT_* macros")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221107230420.4192307-3-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 617bbce6ef8f..57191773572a 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -485,7 +485,7 @@ static void misc(void)
 			goto check_linum;
 
 		ret = read(sk_fds.passive_fd, recv_msg, sizeof(recv_msg));
-		if (ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
+		if (!ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
 			goto check_linum;
 	}
 
@@ -539,7 +539,7 @@ void test_tcp_hdr_options(void)
 		goto skel_destroy;
 
 	cg_fd = test__join_cgroup(CG_NAME);
-	if (ASSERT_GE(cg_fd, 0, "join_cgroup"))
+	if (!ASSERT_GE(cg_fd, 0, "join_cgroup"))
 		goto skel_destroy;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-- 
2.35.1




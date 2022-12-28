Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFFC657C00
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbiL1P1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiL1P1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:27:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FB314038
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4420B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2593EC433D2;
        Wed, 28 Dec 2022 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241261;
        bh=sCGRu5Cad4QczP5ekOdefhRqhZN1nKtzMUlZUOYzmPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omHCxAgvvsobokD2U3cODWJiHE5Rqt6/1vRZAEQ3ya6QpQAcRDXgnAiHNKSmvy/iw
         qDH6r6Okf2iHFrJyCeiJoMM+umD+7YDHMIBO7qhsa58h0cDpnMZRAoiu6Ay6aB2go5
         MXD8FiREKcX0wsG83tq/6L/K8Q8qEofhi012rKU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0210/1146] selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
Date:   Wed, 28 Dec 2022 15:29:09 +0100
Message-Id: <20221228144335.851847004@linuxfoundation.org>
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

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit cbc1c998da59687e8bbc4667154a72eead2daf2d ]

xdp_adjust_tail.c calls ASSERT_OK() to check the return value of
bpf_prog_test_load(), but the condition is not correct. Fix it.

Fixes: 791cad025051 ("bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-7-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 009ee37607df..39973ea1ce43 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -18,7 +18,7 @@ static void test_xdp_adjust_tail_shrink(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
 		return;
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
@@ -53,7 +53,7 @@ static void test_xdp_adjust_tail_grow(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
 		return;
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
@@ -90,7 +90,7 @@ static void test_xdp_adjust_tail_grow2(void)
 	);
 
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
+	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
 		return;
 
 	/* Test case-64 */
-- 
2.35.1




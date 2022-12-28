Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B89657BDF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiL1P0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbiL1P0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:26:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53931B05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:26:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6166B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC3EC433D2;
        Wed, 28 Dec 2022 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241172;
        bh=s478En0Os7ReALXGkickHyrKTTlWG40hydWeRQr2AYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jknII83aboPdNjKSfGIMf0NjOJnONutn/VrtkmcLtQsa6p41Fk+JlWOlcxtLM3/mY
         mVT1UQUcz2QhbjETVTF9Cu62AibArx+BGttCNhrKT/xWkiyBaWmiCqYPAcrLohCtL9
         9vwQtv80VSsNBwEjn7BbHrycmrLYy+08m41z3wKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0209/1146] selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
Date:   Wed, 28 Dec 2022 15:29:08 +0100
Message-Id: <20221228144335.825641967@linuxfoundation.org>
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

[ Upstream commit 4abdb1d5b250df4b5b3afd394d5e2fa516064c04 ]

test_xdp_adjust_tail_grow failed with ipv6:
  test_xdp_adjust_tail_grow:FAIL:ipv6 unexpected error: -28 (errno 28)

The reason is that this test case tests ipv4 before ipv6, and when ipv4
test finished, topts.data_size_out was set to 54, which is smaller than the
ipv6 output data size 114, so ipv6 test fails with NOSPC error.

Fix it by reset topts.data_size_out to sizeof(buf) before testing ipv6.

Fixes: 04fcb5f9a104 ("selftests/bpf: Migrate from bpf_prog_test_run")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-6-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 9b9cf8458adf..009ee37607df 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -63,6 +63,7 @@ static void test_xdp_adjust_tail_grow(void)
 	expect_sz = sizeof(pkt_v6) + 40; /* Test grow with 40 bytes */
 	topts.data_in = &pkt_v6;
 	topts.data_size_in = sizeof(pkt_v6);
+	topts.data_size_out = sizeof(buf);
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
 	ASSERT_OK(err, "ipv6");
 	ASSERT_EQ(topts.retval, XDP_TX, "ipv6 retval");
-- 
2.35.1




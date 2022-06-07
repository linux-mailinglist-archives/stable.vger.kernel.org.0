Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0779540BE8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344371AbiFGScZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352017AbiFGSao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0102F02D;
        Tue,  7 Jun 2022 10:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802F3B8236F;
        Tue,  7 Jun 2022 17:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9957C34115;
        Tue,  7 Jun 2022 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624549;
        bh=OiWcNo8ZYY30dH2anHOyo07VcMU3yIki7I1363nLZfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4EaAwaVxRU95dfnkOXmowNT/ol44cqUm6rHTJZAefwwejOhYmiWYbQSGYAngcKzD
         JVTofQN//zpFXuVbvFINCq09T0lFHqz96bGPrwpchMVNWprYnvGDUdRsZiOffubTAj
         qLGB5u82lwCvUA2MPR4zeyi/nWdlngQF6k0xIvDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/667] selftests/bpf: Add missed ima_setup.sh in Makefile
Date:   Tue,  7 Jun 2022 19:00:15 +0200
Message-Id: <20220607164945.254574806@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 70a1b25326dd77e145157ccf1a31c1948032eec4 ]

When build bpf test and install it to another folder, e.g.

  make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests

The ima_setup.sh is missed in target folder, which makes test_ima failed.

Fix it by adding ima_setup.sh to TEST_PROGS_EXTENDED.

Fixes: 34b82d3ac105 ("bpf: Add a selftest for bpf_ima_inode_hash")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220516040020.653291-1-liuhangbin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 799b88152e9e..638966ae8ad9 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -78,7 +78,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
-	with_tunnels.sh \
+	with_tunnels.sh ima_setup.sh \
 	test_xdp_vlan.sh test_bpftool.py
 
 # Compile but not part of 'make run_tests'
-- 
2.35.1




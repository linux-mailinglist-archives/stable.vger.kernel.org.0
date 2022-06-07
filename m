Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08CD541B7F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbiFGVsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381549AbiFGVrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:47:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162BB237CEA;
        Tue,  7 Jun 2022 12:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8EF61768;
        Tue,  7 Jun 2022 19:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFF2C385A5;
        Tue,  7 Jun 2022 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628880;
        bh=+mJU0yaqab/HXF4PQgrariJN3eV2NGae5tvwWG6vQqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQus4z4gtphYX7i8a7Rx7mhymI5ShtvJYlTwI9QJ6xdZPNGZ8YCwzD+50pzB+IOK+
         2E5PGL6/5ib2ixNABjfxZle5mkyN2wEJ/cvAgXcLdAdW+kJBcgAixlzcBUMIESHdlT
         2tnBmQN4mtDgSKyMa2VykMHKrNDp8VytS1FA1X24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 488/879] selftests/bpf: Add missed ima_setup.sh in Makefile
Date:   Tue,  7 Jun 2022 19:00:06 +0200
Message-Id: <20220607165017.036764604@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index a15c47d2fa73..6e2383701ce0 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -75,7 +75,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
-	with_tunnels.sh \
+	with_tunnels.sh ima_setup.sh \
 	test_xdp_vlan.sh test_bpftool.py
 
 # Compile but not part of 'make run_tests'
-- 
2.35.1




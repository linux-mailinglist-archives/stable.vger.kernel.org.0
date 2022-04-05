Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB64F2E50
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350692AbiDEJ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344199AbiDEJSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B09BB96;
        Tue,  5 Apr 2022 02:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC81F61571;
        Tue,  5 Apr 2022 09:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA80C385A1;
        Tue,  5 Apr 2022 09:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149519;
        bh=Me7CbwGB6LaBferc2IlQNNffvc01zJ+0rfh2uBnaN6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncSbLvfm1uQiNlC94uvrNolVa35XD+VFXqR5EfvJYE6552R9s2AY1NB7XFh1yk0U9
         PZr6qMJcZCAdbdQnsjZli30RgccP/ERIJzw5N9NewpiLz6fLWK7UlT+jmHT8GtnfCF
         dQFWAOjQK1DkbU0HWBUH4nHrYR7hSN9hdFMzkQC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0743/1017] selftests: tls: skip cmsg_to_pipe tests with TLS=n
Date:   Tue,  5 Apr 2022 09:27:36 +0200
Message-Id: <20220405070416.317631773@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5c7e49be96ea24776a5b5a07c732c477294add00 ]

These are negative tests, testing TLS code rejects certain
operations. They won't pass without TLS enabled, pure TCP
accepts those operations.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Fixes: d87d67fd61ef ("selftests: tls: test splicing cmsgs")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 6e468e0f42f7..5d70b04c482c 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -683,6 +683,9 @@ TEST_F(tls, splice_cmsg_to_pipe)
 	char buf[10];
 	int p[2];
 
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
@@ -703,6 +706,9 @@ TEST_F(tls, splice_dec_cmsg_to_pipe)
 	char buf[10];
 	int p[2];
 
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A28F4541DF6
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380728AbiFGWXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385335AbiFGWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9674319948A;
        Tue,  7 Jun 2022 12:21:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF25D60A21;
        Tue,  7 Jun 2022 19:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02756C385A2;
        Tue,  7 Jun 2022 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629680;
        bh=sFYoKH3ur13xudM/5aKhDJvPwSJ1dZo6go0R0tMxJR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0n1rA8QAs0gSntiWvi7IcXcN2OgsUqmEU3Q6D0vMM/q7zqCH8UP7YTPif0l1mufZG
         ElGE2HPU2M0vwh7xe7SH5w2W0nPkNKtx4H9QfPUeKoiHXAey0QQmAjvix8nBGNbIDm
         k/9RufZDiwDMwA0rWryuWucUbN0lxZkHMDcA5BmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 779/879] selftests/landlock: Extend tests for minimal valid attribute size
Date:   Tue,  7 Jun 2022 19:04:57 +0200
Message-Id: <20220607165025.482010559@linuxfoundation.org>
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

From: Mickaël Salaün <mic@digikod.net>

commit 291865bd7e8bb4b4033d341fa02dafa728e6378c upstream.

This might be useful when the struct landlock_ruleset_attr will get more
fields.

Cc: Shuah Khan <shuah@kernel.org>
Link: https://lore.kernel.org/r/20220506160820.524344-4-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/base_test.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -35,6 +35,8 @@ TEST(inconsistent_attr)
 	ASSERT_EQ(EINVAL, errno);
 	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 1, 0));
 	ASSERT_EQ(EINVAL, errno);
+	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 7, 0));
+	ASSERT_EQ(EINVAL, errno);
 
 	ASSERT_EQ(-1, landlock_create_ruleset(NULL, 1, 0));
 	/* The size if less than sizeof(struct landlock_attr_enforce). */
@@ -47,6 +49,9 @@ TEST(inconsistent_attr)
 	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, page_size + 1, 0));
 	ASSERT_EQ(E2BIG, errno);
 
+	/* Checks minimal valid attribute size. */
+	ASSERT_EQ(-1, landlock_create_ruleset(ruleset_attr, 8, 0));
+	ASSERT_EQ(ENOMSG, errno);
 	ASSERT_EQ(-1, landlock_create_ruleset(
 			      ruleset_attr,
 			      sizeof(struct landlock_ruleset_attr), 0));



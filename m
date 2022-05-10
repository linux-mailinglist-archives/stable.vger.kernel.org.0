Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6C521930
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiEJNoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243499AbiEJNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:42:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DF31908;
        Tue, 10 May 2022 06:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54AFFB81DAB;
        Tue, 10 May 2022 13:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB9EC385C9;
        Tue, 10 May 2022 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189446;
        bh=S6iESqWsvrhbvbkUTioFW+6EaW8QdM0/2OaPIP0PLMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghDX50oPwo/UEfevOgg6nf1FaKGPosw2M4btrXqnbkoT4pD2GqEvPd10Gu6655+yg
         B+aGngth4VMrx8JFd3O4AuXn5c6f4FBxreizL+jIN4KdO+aNZg0FCxU66YNF1ky+6d
         I8YBK6apSIs5gQUttdsqNOGJSTsHh40B9S8C/vJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 054/135] selftests/seccomp: Dont call read() on TTY from background pgrp
Date:   Tue, 10 May 2022 15:07:16 +0200
Message-Id: <20220510130741.955512439@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 2bfed7d2ffa5d86c462d3e2067f2832eaf8c04c7 upstream.

Since commit 92d25637a3a4 ("kselftest: signal all child processes"), tests
are executed in background process groups. This means that trying to read
from stdin now throws SIGTTIN when stdin is a TTY, which breaks some
seccomp selftests that try to use read(0, NULL, 0) as a dummy syscall.

The simplest way to fix that is probably to just use -1 instead of 0 as
the dummy read()'s FD.

Fixes: 92d25637a3a4 ("kselftest: signal all child processes")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220319010011.1374622-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -955,7 +955,7 @@ TEST(ERRNO_valid)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(E2BIG, errno);
 }
 
@@ -974,7 +974,7 @@ TEST(ERRNO_zero)
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
 	/* "errno" of 0 is ok. */
-	EXPECT_EQ(0, read(0, NULL, 0));
+	EXPECT_EQ(0, read(-1, NULL, 0));
 }
 
 /*
@@ -995,7 +995,7 @@ TEST(ERRNO_capped)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(4095, errno);
 }
 
@@ -1026,7 +1026,7 @@ TEST(ERRNO_order)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(12, errno);
 }
 
@@ -2579,7 +2579,7 @@ void *tsync_sibling(void *data)
 	ret = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
 	if (!ret)
 		return (void *)SIBLING_EXIT_NEWPRIVS;
-	read(0, NULL, 0);
+	read(-1, NULL, 0);
 	return (void *)SIBLING_EXIT_UNKILLED;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F153521AB8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245122AbiEJODb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245224AbiEJN5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625FF2CDEEE;
        Tue, 10 May 2022 06:39:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE792618A6;
        Tue, 10 May 2022 13:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DF6C385A6;
        Tue, 10 May 2022 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189939;
        bh=k0EV5QDhIv6NUYclbw0DwTvNWUIi+LTqKXOQFZpnxhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD6uBTJgdBtYIQPx1LPAOQaYzIOoljk5tvjIla71HMSJMEJq9DMCI9K84syN42h1l
         UQoQdA/kxwmaviMWLZ6U/WA3src5IpYTRWuwSr7pRcOzTTV+395hrHVmgY/CLEAv18
         NkvGlw1SAihk2d3rtUf7hMK5xydz2kGwahplRb70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.17 076/140] selftests/seccomp: Dont call read() on TTY from background pgrp
Date:   Tue, 10 May 2022 15:07:46 +0200
Message-Id: <20220510130743.788485575@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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
 
@@ -2623,7 +2623,7 @@ void *tsync_sibling(void *data)
 	ret = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
 	if (!ret)
 		return (void *)SIBLING_EXIT_NEWPRIVS;
-	read(0, NULL, 0);
+	read(-1, NULL, 0);
 	return (void *)SIBLING_EXIT_UNKILLED;
 }
 



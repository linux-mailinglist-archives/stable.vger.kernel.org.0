Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E353F5218B9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243663AbiEJNjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244855AbiEJNiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAA26D4CA;
        Tue, 10 May 2022 06:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD8B1B81DA9;
        Tue, 10 May 2022 13:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E0EC385C2;
        Tue, 10 May 2022 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189190;
        bh=/pxfULk7hU6DIw/b2kQ1JQq9ZuRhMqqC4/KdmYm/oPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTk1P73H93NTPxeMP9J+s/XTaBniYChls2kWi9pe3FiRSAet9PpvMmh2LSREjft7w
         WYjKdAy6JRxjUXisEt+RalD59NmWVvmSCkoxzxlotFYb5fLooqdSdUafMEnFe90VVw
         AsQkUcgMwA+rjwY6mQGuEvVjH/JgUDUNRyCvhqe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 42/70] selftests/seccomp: Dont call read() on TTY from background pgrp
Date:   Tue, 10 May 2022 15:08:01 +0200
Message-Id: <20220510130734.091625379@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
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
@@ -951,7 +951,7 @@ TEST(ERRNO_valid)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(E2BIG, errno);
 }
 
@@ -970,7 +970,7 @@ TEST(ERRNO_zero)
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
 	/* "errno" of 0 is ok. */
-	EXPECT_EQ(0, read(0, NULL, 0));
+	EXPECT_EQ(0, read(-1, NULL, 0));
 }
 
 /*
@@ -991,7 +991,7 @@ TEST(ERRNO_capped)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(4095, errno);
 }
 
@@ -1022,7 +1022,7 @@ TEST(ERRNO_order)
 	ASSERT_EQ(0, ret);
 
 	EXPECT_EQ(parent, syscall(__NR_getppid));
-	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(-1, read(-1, NULL, 0));
 	EXPECT_EQ(12, errno);
 }
 
@@ -2575,7 +2575,7 @@ void *tsync_sibling(void *data)
 	ret = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
 	if (!ret)
 		return (void *)SIBLING_EXIT_NEWPRIVS;
-	read(0, NULL, 0);
+	read(-1, NULL, 0);
 	return (void *)SIBLING_EXIT_UNKILLED;
 }
 



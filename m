Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368EA6AECD4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCGR6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCGR5z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE79FA17CA;
        Tue,  7 Mar 2023 09:52:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A160614B2;
        Tue,  7 Mar 2023 17:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EF7C433EF;
        Tue,  7 Mar 2023 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211542;
        bh=HXq/6ZjXuusXiycdbXpA5n7j8u0nZx0cU+AyOrSbcWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9U/qEKVdfsf6JHS6+68ydwCErN6mTZLyy6k1K5SXUs5NknHxbYZ4D1g0OQdWulO2
         4WqxcL5NARQrJCJB5DsZJMOjx0w1KJzieNnp7Js0nBZfZFz2ZTBpG58hli8/oWpSuz
         ei3Nj8hlSE+X2YkB0E0eqgG+8PEaqYeh+YKWRR9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0866/1001] selftests: filesystems: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:38 +0100
Message-Id: <20230307170059.451584358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit c2d3cf3653a8ff6e4b402d55e7f84790ac08a8ad upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/filesystems/Makefile          |    2 +-
 tools/testing/selftests/filesystems/binderfs/Makefile |    2 +-
 tools/testing/selftests/filesystems/epoll/Makefile    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := devpts_pts
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
--- a/tools/testing/selftests/filesystems/binderfs/Makefile
+++ b/tools/testing/selftests/filesystems/binderfs/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/ -pthread
+CFLAGS += $(KHDR_INCLUDES) -pthread
 TEST_GEN_PROGS := binderfs_test
 
 binderfs_test: binderfs_test.c ../../kselftest.h ../../kselftest_harness.h
--- a/tools/testing/selftests/filesystems/epoll/Makefile
+++ b/tools/testing/selftests/filesystems/epoll/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 LDLIBS += -lpthread
 TEST_GEN_PROGS := epoll_wakeup_test
 



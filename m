Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599124BD47
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHTNCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgHTJkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:40:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7A2207DE;
        Thu, 20 Aug 2020 09:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916405;
        bh=Fvc9UXGsW1DFRUYgaLHQ4OIRUcxpki4GOebzhOUscyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TN9jlKGnT6uX/2Ec/b3jMctbjZU4ImVa1pd5NV94QoCOu24mVkr8fU5RmPCnfaXuS
         zVY5LfGTtoMobtpeSnu7hk6lvUrNzGoFNR5C1qrJFYxvapxO8P+2tBl1JCRetUl5pX
         r2eMgRNU3nR/B6yJocpggbgDnV7cOK5+Jv6HbwcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 116/204] selftests/bpf: test_progs avoid minus shell exit codes
Date:   Thu, 20 Aug 2020 11:20:13 +0200
Message-Id: <20200820091612.105493726@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit b8c50df0cb3eb9008f8372e4ff0317eee993b8d1 ]

There are a number of places in test_progs that use minus-1 as the argument
to exit(). This is confusing as a process exit status is masked to be a
number between 0 and 255 as defined in man exit(3). Thus, users will see
status 255 instead of minus-1.

This patch use positive exit code 3 instead of minus-1. These cases are put
in the same group of infrastructure setup errors.

Fixes: fd27b1835e70 ("selftests/bpf: Reset process and thread affinity after each test/sub-test")
Fixes: 811d7e375d08 ("bpf: selftests: Restore netns after each test")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/159410594499.1093222.11080787853132708654.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index a75a83155f6d0..c2eb58382113a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -13,6 +13,7 @@
 #include <execinfo.h> /* backtrace */
 
 #define EXIT_NO_TEST		2
+#define EXIT_ERR_SETUP_INFRA	3
 
 /* defined in test_progs.h */
 struct test_env env = {};
@@ -113,13 +114,13 @@ static void reset_affinity() {
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 	err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 
@@ -128,7 +129,7 @@ static void save_netns(void)
 	env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
 	if (env.saved_netns_fd == -1) {
 		perror("open(/proc/self/ns/net)");
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 
@@ -137,7 +138,7 @@ static void restore_netns(void)
 	if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
 		stdio_restore();
 		perror("setns(CLONE_NEWNS)");
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 
-- 
2.25.1




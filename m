Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22E285D00
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgJGKgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 06:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgJGKgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 06:36:43 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1315AC061755;
        Wed,  7 Oct 2020 03:36:43 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4C5rNk6tpzzKmh1;
        Wed,  7 Oct 2020 12:36:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id GCodGCpHNCIN; Wed,  7 Oct 2020 12:36:32 +0200 (CEST)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>
Cc:     Aleksa Sarai <cyphar@cyphar.com>, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        containers@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] openat2: reject RESOLVE_BENEATH|RESOLVE_IN_ROOT
Date:   Wed,  7 Oct 2020 21:36:08 +1100
Message-Id: <20201007103608.17349-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -7.86 / 15.00 / 15.00
X-Rspamd-Queue-Id: 94FA014AF
X-Rspamd-UID: 962eff
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This was an oversight in the original implementation, as it makes no
sense to specify both scoping flags to the same openat2(2) invocation
(before this patch, the result of such an invocation was equivalent to
RESOLVE_IN_ROOT being ignored).

This is a userspace-visible ABI change, but the only user of openat2(2)
at the moment is LXC which doesn't specify both flags and so no
userspace programs will break as a result.

Cc: <stable@vger.kernel.org> # v5.6+
Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/open.c                                      | 4 ++++
 tools/testing/selftests/openat2/openat2_test.c | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 9af548fb841b..4d7537ae59df 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1010,6 +1010,10 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
 	if (how->resolve & ~VALID_RESOLVE_FLAGS)
 		return -EINVAL;
 
+	/* Scoping flags are mutually exclusive. */
+	if ((how->resolve & RESOLVE_BENEATH) && (how->resolve & RESOLVE_IN_ROOT))
+		return -EINVAL;
+
 	/* Deal with the mode. */
 	if (WILL_CREATE(flags)) {
 		if (how->mode & ~S_IALLUGO)
diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
index b386367c606b..381d874cce99 100644
--- a/tools/testing/selftests/openat2/openat2_test.c
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -155,7 +155,7 @@ struct flag_test {
 	int err;
 };
 
-#define NUM_OPENAT2_FLAG_TESTS 23
+#define NUM_OPENAT2_FLAG_TESTS 24
 
 void test_openat2_flags(void)
 {
@@ -210,6 +210,12 @@ void test_openat2_flags(void)
 		  .how.flags = O_TMPFILE | O_RDWR,
 		  .how.mode = 0x0000A00000000000ULL, .err = -EINVAL },
 
+		/* ->resolve flags must not conflict. */
+		{ .name = "incompatible resolve flags (BENEATH | IN_ROOT)",
+		  .how.flags = O_RDONLY,
+		  .how.resolve = RESOLVE_BENEATH | RESOLVE_IN_ROOT,
+		  .err = -EINVAL },
+
 		/* ->resolve must only contain RESOLVE_* flags. */
 		{ .name = "invalid how.resolve and O_RDONLY",
 		  .how.flags = O_RDONLY,
-- 
2.28.0


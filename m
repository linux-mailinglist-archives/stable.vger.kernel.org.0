Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9288A48000A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhL0Pmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40212 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbhL0Pkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 634D1610E8;
        Mon, 27 Dec 2021 15:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487E7C36AEA;
        Mon, 27 Dec 2021 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619650;
        bh=u+Lea+G3PkEhV5H67ZQ6fbCOEyDDgoPyA4zAEwd5W6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sv7aaMtliw0ZFJ9b+xe3ui/8F2A8D5D/XG2wQEZIJURXD0ZOF9vWUBrcFjVQmf9fi
         yLssu9ZQbt31sA4UDRbifSkeOIJoRAwk4Ae+SPJl1/A6cj7UFM5EOWLUbomhd151Fd
         lf5sMWgdmPx2u88jSabyP3d7IMWCiNmsP8+KWDBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/128] ucounts: Fix rlimit max values check
Date:   Mon, 27 Dec 2021 16:29:49 +0100
Message-Id: <20211227151331.992220098@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 59ec71575ab440cd5ca0aa53b2a2985b3639fad4 ]

The semantics of the rlimit max values differs from ucounts itself. When
creating a new userns, we store the current rlimit of the process in
ucount_max. Thus, the value of the limit in the parent userns is saved
in the created one.

The problem is that now we are taking the maximum value for counter from
the same userns. So for init_user_ns it will always be RLIM_INFINITY.

To fix the problem we need to check the counter value with the max value
stored in userns.

Reproducer:

su - test -c "ulimit -u 3; sleep 5 & sleep 6 & unshare -U --map-root-user sh -c 'sleep 7 & sleep 8 & date; wait'"

Before:

[1] 175
[2] 176
Fri Nov 26 13:48:20 UTC 2021
[1]-  Done                    sleep 5
[2]+  Done                    sleep 6

After:

[1] 167
[2] 168
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: retry: Resource temporarily unavailable
sh: fork: Interrupted system call
[1]-  Done                    sleep 5
[2]+  Done                    sleep 6

Fixes: c54b245d0118 ("Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace")
Reported-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Link: https://lkml.kernel.org/r/024ec805f6e16896f0b23e094773790d171d2c1c.1638218242.git.legion@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index eb03f3c68375d..16feb710ee638 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -258,15 +258,16 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 {
 	struct ucounts *iter;
+	long max = LONG_MAX;
 	long ret = 0;
 
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		long max = READ_ONCE(iter->ns->ucount_max[type]);
 		long new = atomic_long_add_return(v, &iter->ucount[type]);
 		if (new < 0 || new > max)
 			ret = LONG_MAX;
 		else if (iter == ucounts)
 			ret = new;
+		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}
 	return ret;
 }
@@ -306,15 +307,16 @@ long inc_rlimit_get_ucounts(struct ucounts *ucounts, enum ucount_type type)
 {
 	/* Caller must hold a reference to ucounts */
 	struct ucounts *iter;
+	long max = LONG_MAX;
 	long dec, ret = 0;
 
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		long max = READ_ONCE(iter->ns->ucount_max[type]);
 		long new = atomic_long_add_return(1, &iter->ucount[type]);
 		if (new < 0 || new > max)
 			goto unwind;
 		if (iter == ucounts)
 			ret = new;
+		max = READ_ONCE(iter->ns->ucount_max[type]);
 		/*
 		 * Grab an extra ucount reference for the caller when
 		 * the rlimit count was previously 0.
@@ -333,15 +335,16 @@ unwind:
 	return 0;
 }
 
-bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long max)
+bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long rlimit)
 {
 	struct ucounts *iter;
-	if (get_ucounts_value(ucounts, type) > max)
-		return true;
+	long max = rlimit;
+	if (rlimit > LONG_MAX)
+		max = LONG_MAX;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		max = READ_ONCE(iter->ns->ucount_max[type]);
 		if (get_ucounts_value(iter, type) > max)
 			return true;
+		max = READ_ONCE(iter->ns->ucount_max[type]);
 	}
 	return false;
 }
-- 
2.34.1




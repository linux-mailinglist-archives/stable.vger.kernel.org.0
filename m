Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A564A164
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiLLNjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiLLNjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:39:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE9014D1C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:38:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41524CE0F7F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3F4C433EF;
        Mon, 12 Dec 2022 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852304;
        bh=pOCHCiYSjZiGlGXCgCR6tGT5TX8Z0xcSfliAYwREkcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyZJxZe7YyfGdg6VScV8nG13x9SmRIQ6DqswMuh3aI84JkQr93yp25sS/fcdyqBpK
         Rr+OEAJ3lJF1PrXr+sgSw/QhiX5f3Lp5lT3x1wdmxS3gCbZWQyED5PiwHbWTrEf/5S
         08wZEdgvl7Gqa5NqSUutqcLBsOzJJunlpPyXX1nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daire Byrne <daire.byrne@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Daire Byrne <daire@dneg.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 054/157] fscache: Fix oops due to race with cookie_lru and use_cookie
Date:   Mon, 12 Dec 2022 14:16:42 +0100
Message-Id: <20221212130936.729610218@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit b5b52de3214a29911f949459a79f6640969b5487 ]

If a cookie expires from the LRU and the LRU_DISCARD flag is set, but
the state machine has not run yet, it's possible another thread can call
fscache_use_cookie and begin to use it.

When the cookie_worker finally runs, it will see the LRU_DISCARD flag
set, transition the cookie->state to LRU_DISCARDING, which will then
withdraw the cookie.  Once the cookie is withdrawn the object is removed
the below oops will occur because the object associated with the cookie
is now NULL.

Fix the oops by clearing the LRU_DISCARD bit if another thread uses the
cookie before the cookie_worker runs.

  BUG: kernel NULL pointer dereference, address: 0000000000000008
  ...
  CPU: 31 PID: 44773 Comm: kworker/u130:1 Tainted: G     E    6.0.0-5.dneg.x86_64 #1
  Hardware name: Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
  Workqueue: events_unbound netfs_rreq_write_to_cache_work [netfs]
  RIP: 0010:cachefiles_prepare_write+0x28/0x90 [cachefiles]
  ...
  Call Trace:
    netfs_rreq_write_to_cache_work+0x11c/0x320 [netfs]
    process_one_work+0x217/0x3e0
    worker_thread+0x4a/0x3b0
    kthread+0xd6/0x100

Fixes: 12bb21a29c19 ("fscache: Implement cookie user counting and resource pinning")
Reported-by: Daire Byrne <daire.byrne@gmail.com>
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Daire Byrne <daire@dneg.com>
Link: https://lore.kernel.org/r/20221117115023.1350181-1-dwysocha@redhat.com/ # v1
Link: https://lore.kernel.org/r/20221117142915.1366990-1-dwysocha@redhat.com/ # v2
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/cookie.c            | 8 ++++++++
 include/trace/events/fscache.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 451d8a077e12..bce2492186d0 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -605,6 +605,14 @@ void __fscache_use_cookie(struct fscache_cookie *cookie, bool will_modify)
 			set_bit(FSCACHE_COOKIE_DO_PREP_TO_WRITE, &cookie->flags);
 			queue = true;
 		}
+		/*
+		 * We could race with cookie_lru which may set LRU_DISCARD bit
+		 * but has yet to run the cookie state machine.  If this happens
+		 * and another thread tries to use the cookie, clear LRU_DISCARD
+		 * so we don't end up withdrawing the cookie while in use.
+		 */
+		if (test_and_clear_bit(FSCACHE_COOKIE_DO_LRU_DISCARD, &cookie->flags))
+			fscache_see_cookie(cookie, fscache_cookie_see_lru_discard_clear);
 		break;
 
 	case FSCACHE_COOKIE_STATE_FAILED:
diff --git a/include/trace/events/fscache.h b/include/trace/events/fscache.h
index c078c48a8e6d..a6190aa1b406 100644
--- a/include/trace/events/fscache.h
+++ b/include/trace/events/fscache.h
@@ -66,6 +66,7 @@ enum fscache_cookie_trace {
 	fscache_cookie_put_work,
 	fscache_cookie_see_active,
 	fscache_cookie_see_lru_discard,
+	fscache_cookie_see_lru_discard_clear,
 	fscache_cookie_see_lru_do_one,
 	fscache_cookie_see_relinquish,
 	fscache_cookie_see_withdraw,
@@ -149,6 +150,7 @@ enum fscache_access_trace {
 	EM(fscache_cookie_put_work,		"PQ  work ")		\
 	EM(fscache_cookie_see_active,		"-   activ")		\
 	EM(fscache_cookie_see_lru_discard,	"-   x-lru")		\
+	EM(fscache_cookie_see_lru_discard_clear,"-   lrudc")            \
 	EM(fscache_cookie_see_lru_do_one,	"-   lrudo")		\
 	EM(fscache_cookie_see_relinquish,	"-   x-rlq")		\
 	EM(fscache_cookie_see_withdraw,		"-   x-wth")		\
-- 
2.35.1




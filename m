Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1971559D4EF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbiHWIml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346705AbiHWIk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1785F23F;
        Tue, 23 Aug 2022 01:18:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F22161321;
        Tue, 23 Aug 2022 08:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABFCC433C1;
        Tue, 23 Aug 2022 08:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242645;
        bh=GOO6yS8sqZfWknrUvzaIwJRwSqyMq+57shxE+fO7O2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHs0RuaFD73IhUymSU4FpXwCBmPlN8B4ESMLOPvyLlais20CycC2UrVqA4XN3AZvL
         dJd8h/J+GxanPbPe0KFFwt/GPe4KDKYKzaH74w71xEpV8ulkUrf793SIE/OVbdA90K
         OBcP8s4E6a0kYdTs7P5su//a4jytK+tmrvtO21Kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.19 152/365] fscache: dont leak cookie access refs if invalidation is in progress or failed
Date:   Tue, 23 Aug 2022 10:00:53 +0200
Message-Id: <20220823080124.585754011@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff Layton <jlayton@kernel.org>

commit fb24771faf72a2fd62b3b6287af3c610c3ec9cf1 upstream.

It's possible for a request to invalidate a fscache_cookie will come in
while we're already processing an invalidation. If that happens we
currently take an extra access reference that will leak. Only call
__fscache_begin_cookie_access if the FSCACHE_COOKIE_DO_INVALIDATE bit
was previously clear.

Also, ensure that we attempt to clear the bit when the cookie is
"FAILED" and put the reference to avoid an access leak.

Fixes: 85e4ea1049c7 ("fscache: Fix invalidation/lookup race")
Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fscache/cookie.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 74920826d8f6..26a6d395737a 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -739,6 +739,9 @@ static void fscache_cookie_state_machine(struct fscache_cookie *cookie)
 		fallthrough;
 
 	case FSCACHE_COOKIE_STATE_FAILED:
+		if (test_and_clear_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags))
+			fscache_end_cookie_access(cookie, fscache_access_invalidate_cookie_end);
+
 		if (atomic_read(&cookie->n_accesses) != 0)
 			break;
 		if (test_bit(FSCACHE_COOKIE_DO_RELINQUISH, &cookie->flags)) {
@@ -1063,8 +1066,8 @@ void __fscache_invalidate(struct fscache_cookie *cookie,
 		return;
 
 	case FSCACHE_COOKIE_STATE_LOOKING_UP:
-		__fscache_begin_cookie_access(cookie, fscache_access_invalidate_cookie);
-		set_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags);
+		if (!test_and_set_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags))
+			__fscache_begin_cookie_access(cookie, fscache_access_invalidate_cookie);
 		fallthrough;
 	case FSCACHE_COOKIE_STATE_CREATING:
 		spin_unlock(&cookie->lock);
-- 
2.37.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C2756FBA1
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiGKJda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiGKJc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9639B78DD7;
        Mon, 11 Jul 2022 02:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A18F6122D;
        Mon, 11 Jul 2022 09:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1939DC34115;
        Mon, 11 Jul 2022 09:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531058;
        bh=DoAdjjA6vsIejV4loK50pbT1nheKnTBbr6OKl7P5HVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xI2r2tV2oaCCmHe8jjDMDLyEbyEtQaxqRhy2mMYSe2pefYuoQprR+rruR23qvVTm2
         fTaRFsOMO9+b0YPNuje1LW+5s4WFWRZzQxrO506r3t2PTK2RO7VIv61lCqJSEl8VVj
         mUxaxM5Sl8vFsfjjFv0sDhEKbiR1SOBtXxueEESs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 5.18 041/112] fscache: Fix invalidation/lookup race
Date:   Mon, 11 Jul 2022 11:06:41 +0200
Message-Id: <20220711090550.739560152@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 85e4ea1049c70fb99de5c6057e835d151fb647da upstream.

If an NFS file is opened for writing and closed, fscache_invalidate() will
be asked to invalidate the file - however, if the cookie is in the
LOOKING_UP state (or the CREATING state), then request to invalidate
doesn't get recorded for fscache_cookie_state_machine() to do something
with.

Fix this by making __fscache_invalidate() set a flag if it sees the cookie
is in the LOOKING_UP state to indicate that we need to go to invalidation.
Note that this requires a count on the n_accesses counter for the state
machine, which that will release when it's done.

fscache_cookie_state_machine() then shifts to the INVALIDATING state if it
sees the flag.

Without this, an nfs file can get corrupted if it gets modified locally and
then read locally as the cache contents may not get updated.

Fixes: d24af13e2e23 ("fscache: Implement cookie invalidation")
Reported-by: Max Kellermann <mk@cm4all.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Max Kellermann <mk@cm4all.com>
Link: https://lore.kernel.org/r/YlWWbpW5Foynjllo@rabbit.intern.cm-ag [1]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fscache/cookie.c     |   15 ++++++++++++++-
 include/linux/fscache.h |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -517,7 +517,14 @@ static void fscache_perform_lookup(struc
 	}
 
 	fscache_see_cookie(cookie, fscache_cookie_see_active);
-	fscache_set_cookie_state(cookie, FSCACHE_COOKIE_STATE_ACTIVE);
+	spin_lock(&cookie->lock);
+	if (test_and_clear_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags))
+		__fscache_set_cookie_state(cookie,
+					   FSCACHE_COOKIE_STATE_INVALIDATING);
+	else
+		__fscache_set_cookie_state(cookie, FSCACHE_COOKIE_STATE_ACTIVE);
+	spin_unlock(&cookie->lock);
+	wake_up_cookie_state(cookie);
 	trace = fscache_access_lookup_cookie_end;
 
 out:
@@ -752,6 +759,9 @@ again_locked:
 			spin_lock(&cookie->lock);
 		}
 
+		if (test_and_clear_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags))
+			fscache_end_cookie_access(cookie, fscache_access_invalidate_cookie_end);
+
 		switch (state) {
 		case FSCACHE_COOKIE_STATE_RELINQUISHING:
 			fscache_see_cookie(cookie, fscache_cookie_see_relinquish);
@@ -1048,6 +1058,9 @@ void __fscache_invalidate(struct fscache
 		return;
 
 	case FSCACHE_COOKIE_STATE_LOOKING_UP:
+		__fscache_begin_cookie_access(cookie, fscache_access_invalidate_cookie);
+		set_bit(FSCACHE_COOKIE_DO_INVALIDATE, &cookie->flags);
+		fallthrough;
 	case FSCACHE_COOKIE_STATE_CREATING:
 		spin_unlock(&cookie->lock);
 		_leave(" [look %x]", cookie->inval_counter);
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -129,6 +129,7 @@ struct fscache_cookie {
 #define FSCACHE_COOKIE_DO_PREP_TO_WRITE	12		/* T if cookie needs write preparation */
 #define FSCACHE_COOKIE_HAVE_DATA	13		/* T if this cookie has data stored */
 #define FSCACHE_COOKIE_IS_HASHED	14		/* T if this cookie is hashed */
+#define FSCACHE_COOKIE_DO_INVALIDATE	15		/* T if cookie needs invalidation */
 
 	enum fscache_cookie_state	state;
 	u8				advice;		/* FSCACHE_ADV_* */



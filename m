Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63BB6CC2D6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjC1OtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjC1Osq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD75C155;
        Tue, 28 Mar 2023 07:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C473F61826;
        Tue, 28 Mar 2023 14:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6054C433EF;
        Tue, 28 Mar 2023 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014903;
        bh=4Y8/xJhwU7aJXJUzYvMwx8jzSFFEXA9tPwndwM5aX+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqIVVzpUm8m4ymi6Elj0QtIKmvFzparOAcowwKp9uAsfxPw8hFuwVrNgPucmCEJHK
         veXDll+HlwuntJktcxeR/MLXTzNqcjf7G+gftu4bQdMftEmxcLh78IrDY7XmX+RvF3
         g+3O4nO1kkbtbyFm9EurTHWsWw++W7EAj6seKUzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bharath SM <bharathsm@microsoft.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>, keyrings@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 067/240] keys: Do not cache key in task struct if key is requested from kernel thread
Date:   Tue, 28 Mar 2023 16:40:30 +0200
Message-Id: <20230328142622.530564908@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 47f9e4c924025c5be87959d3335e66fcbb7f6b5c ]

The key which gets cached in task structure from a kernel thread does not
get invalidated even after expiry.  Due to which, a new key request from
kernel thread will be served with the cached key if it's present in task
struct irrespective of the key validity.  The change is to not cache key in
task_struct when key requested from kernel thread so that kernel thread
gets a valid key on every key request.

The problem has been seen with the cifs module doing DNS lookups from a
kernel thread and the results getting pinned by being attached to that
kernel thread's cache - and thus not something that can be easily got rid
of.  The cache would ordinarily be cleared by notify-resume, but kernel
threads don't do that.

This isn't seen with AFS because AFS is doing request_key() within the
kernel half of a user thread - which will do notify-resume.

Fixes: 7743c48e54ee ("keys: Cache result of request_key*() temporarily in task_struct")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Steve French <smfrench@gmail.com>
cc: keyrings@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/CAGypqWw951d=zYRbdgNR4snUDvJhWL=q3=WOyh7HhSJupjz2vA@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/request_key.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 2da4404276f0f..07a0ef2baacd8 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -38,9 +38,12 @@ static void cache_requested_key(struct key *key)
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	struct task_struct *t = current;
 
-	key_put(t->cached_requested_key);
-	t->cached_requested_key = key_get(key);
-	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	/* Do not cache key if it is a kernel thread */
+	if (!(t->flags & PF_KTHREAD)) {
+		key_put(t->cached_requested_key);
+		t->cached_requested_key = key_get(key);
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	}
 #endif
 }
 
-- 
2.39.2




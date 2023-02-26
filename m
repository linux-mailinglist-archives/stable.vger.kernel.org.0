Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BFB6A2E06
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBZD73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBZD71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:59:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0EE8A47;
        Sat, 25 Feb 2023 19:59:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD53CB80B8C;
        Sun, 26 Feb 2023 03:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57EFC4339B;
        Sun, 26 Feb 2023 03:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383046;
        bh=oIxAghDco1nlJELtPYxjKDbkxc75lnrjoUyKv7UPHI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6cGkJaWjTcT5eeGE8Sp6fpB5zu9bl02b04FN9kqT5Svnnil2Ku+qa2gS5yDFSKX0
         W8pAGYmwuxyP7gUhtMuLFP8D9/OosgtClCdgNIcwTaYkrsauPT77M78RubXsMVl6Yv
         c8xvWcOjWW0g5Aqa7v3H/1J16oLOtuWOItuOFffBgh3UpKvgRqFeUV7TpQ8wsMrFIz
         08q9VZJYwzC6upvQczr1mDw5+IbtE8sfNpKtHSmarreS4DZlImnf0V9IkuJGxbpaG6
         CHf9wFh/9r4JhEH9Y++iymqY2bU1iE94eAnhgI8xAcDCq99Xuj42yfcJNEOYfRHJ2T
         uOTMM2gOF6ZhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 5/6] fs/super.c: stop calling fscrypt_destroy_keyring() from __put_super()
Date:   Sat, 25 Feb 2023 22:43:57 -0500
Message-Id: <20230226034359.773806-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034359.773806-1-sashal@kernel.org>
References: <20230226034359.773806-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit ec64036e68634231f5891faa2b7a81cdc5dcd001 ]

Now that the key associated with the "test_dummy_operation" mount option
is added on-demand when it's needed, rather than immediately when the
filesystem is mounted, fscrypt_destroy_keyring() no longer needs to be
called from __put_super() to avoid a memory leak on mount failure.

Remove this call, which was causing confusion because it appeared to be
a sleep-in-atomic bug (though it wasn't, for a somewhat-subtle reason).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20230208062107.199831-5-ebiggers@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/super.c b/fs/super.c
index 7fa3ee79ec898..4eeb0b47412ae 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -293,7 +293,6 @@ static void __put_super(struct super_block *s)
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(!list_empty(&s->s_mounts));
 		security_sb_free(s);
-		fscrypt_destroy_keyring(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
 		call_rcu(&s->rcu, destroy_super_rcu);
-- 
2.39.0


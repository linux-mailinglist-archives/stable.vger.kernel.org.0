Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725AD6A2DB4
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBZDpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBZDog (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:44:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFBBD17CE3;
        Sat, 25 Feb 2023 19:44:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB52B80B8F;
        Sun, 26 Feb 2023 03:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D79C4339C;
        Sun, 26 Feb 2023 03:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382997;
        bh=Eig9/5/gmSof0DEms9mCjk4m3+ppAUCTgwGMVVF+Ffo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGlt1a7ohE7L/G9DHzzwd1/dl+zhz9s8tkGpeIFlkPa8jg6cSIluDwcdpBeCTmnFP
         uKo1crBo2TL/GsKN3i6KlLNot9UnJxyIPQOXvbvkxTb1w5+nLnsh1ugGxae/OTZSgu
         evoADzqSqUZSMT6T1XoW4fAQ/QBPICz4lm7DurQeHYX8S/sHFqtpZpOjqrNGGziBqq
         dRi9IUQd5Y9xQMwmc0AvoRshd8SJGpjUaolfs7epKpOqzAFUrkM2Ilk5iSqA6HdEDh
         fn7jRTa/6jvOA1BsFjxL6WM5YKMClAOErPjxRfaFQN7BUDCQyhbQlPiUKV0Gj9o2fd
         HMg1J5thVEkPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 12/21] fs/super.c: stop calling fscrypt_destroy_keyring() from __put_super()
Date:   Sat, 25 Feb 2023 22:42:47 -0500
Message-Id: <20230226034256.771769-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034256.771769-1-sashal@kernel.org>
References: <20230226034256.771769-1-sashal@kernel.org>
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
index 4f8a626a35cd9..76d47620b930d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -291,7 +291,6 @@ static void __put_super(struct super_block *s)
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(!list_empty(&s->s_mounts));
 		security_sb_free(s);
-		fscrypt_destroy_keyring(s);
 		put_user_ns(s->s_user_ns);
 		kfree(s->s_subtype);
 		call_rcu(&s->rcu, destroy_super_rcu);
-- 
2.39.0


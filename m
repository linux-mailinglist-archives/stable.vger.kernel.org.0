Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956686CFC6E
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 09:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjC3HNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 03:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjC3HNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 03:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F96E8B;
        Thu, 30 Mar 2023 00:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D39C61F1B;
        Thu, 30 Mar 2023 07:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913F7C4339B;
        Thu, 30 Mar 2023 07:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680160402;
        bh=G/raK3ocYVegw3OGWU88n2Ffrz9wyE2LoLFozbjp/Q0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=r+buEN7fejd0laG635oaSqHZcv+5essLQfQu1v4G4/qQggbkeNNimQ0XxuTzSkIj1
         JIxbGYaR5b1w+ob2xDSpqSU5GsghUwnusFvsKFHeROCnV9l+wlEXuOk9X+9uJvUzCo
         FSdE1bsMJsb7uwXfUcmnoEzkCMSz+pBhjJhGfzBjY/UCikmksHZ20KmMMxslkc6bca
         yMQcM424mIg+YLovsX+pykjnwfUbaoDNnPOmpT0An4t+m+E5/mNWTEytUgf9iWs/f7
         YkT0w/6MwUz3xwSgVkKeShrFrwQQYp6xR7v34S/b24AWi5i+F6K/FKWPjPsUVcFnIT
         PQNKn+OmY66YA==
Date:   Thu, 30 Mar 2023 09:13:16 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: [PATCH] fs: drop peer group ids under namespace lock
Message-ID: <20230330-vfs-mount_setattr-propagation-fix-v1-1-37548d91533b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI41JWQC/x2NwQqDMBBEf0Vy7kJqaKX9lVLKJm40B5Owu0pB/
 PfGHh8z82Y3QpxIzLPbDdOWJJXc4HrpTJgxTwRpbGx62zvrnIUtCixlzfoRUlRlqFwqTqhtCTF
 9wd2dH8LtMQ7Rm+bxKASeMYf5NC0oSnwGlan1/+ev93H8ALwgrQGMAAAA
X-Mailer: b4 0.13-dev-00303
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6ePqaCE6h84elZe3L+tFR/+iRaxe2PhzaSxvtZilVWk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSomvbZHl0dvkNr6p0/qf2pTvd1ZL1jnm659dggr78+yX9t
 74ZTHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM5v56RYWWKc6K0ae2qulSBhx8UmK
 /OqRFXigmKTlQSWGOgvnHuL0aGRfyfXvXtnpq9T9j3dVMBi4yN8sb5XKvu565YXr9ctS+NGwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <00000000000088694505f8132d77@google.com>
 <000000000000a0139105f81888eb@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When cleaning up peer group ids in the failure path we need to make sure
to hold on to the namespace lock. Otherwise another thread might just
turn the mount from a shared into a non-shared mount concurrently.

Reported-by: syzbot+8ac3859139c685c4f597@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/00000000000088694505f8132d77@google.com
Fixes: 2a1867219c7b ("fs: add mount_setattr()")
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bc0f15257b49..6836e937ee61 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4183,9 +4183,9 @@ static int do_mount_setattr(struct path *path, struct mount_kattr *kattr)
 	unlock_mount_hash();
 
 	if (kattr->propagation) {
-		namespace_unlock();
 		if (err)
 			cleanup_group_ids(mnt, NULL);
+		namespace_unlock();
 	}
 
 	return err;

---
base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
change-id: 20230330-vfs-mount_setattr-propagation-fix-363b7c59d7fb


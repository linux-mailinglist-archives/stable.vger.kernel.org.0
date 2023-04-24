Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22476ED281
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 18:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDXQch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjDXQcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 12:32:36 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B276949FD;
        Mon, 24 Apr 2023 09:32:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 48DCC219BC;
        Mon, 24 Apr 2023 16:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682353946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8GGs5u6/2RthBLwEQN1YHuOkz+P0Gi/3mPEHA+xUwF4=;
        b=U47HNvDhNrLqetMP5Y5nR3lkUP6CdfTyAOUnIZV2e3G60gEgr0k49oS8Y9RtwoR3ePytQS
        3JVtoBalxLE8dyZ+0Mxmp8N7z6F7V6t5+51XHmzzkWHImVLI2tDUkg9Uo0pMVLqlglRcw3
        2FwNwVuRrg3TOW8rkSKrtR/+Pr5hIHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682353946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=8GGs5u6/2RthBLwEQN1YHuOkz+P0Gi/3mPEHA+xUwF4=;
        b=SlYVVuXS/SFA69Qmn7hHmQGr6WypnA3f2efVMFDlIMpG+EyVk2VTSgv4cmrTxYUB8aR0vF
        oc3n7p2tEoClOaCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C3C21390E;
        Mon, 24 Apr 2023 16:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uA+/ChqvRmQZDQAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 24 Apr 2023 16:32:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 6A7DBA0729; Mon, 24 Apr 2023 18:32:25 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org,
        syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
Subject: [PATCH] inotify: Avoid reporting event with invalid wd
Date:   Mon, 24 Apr 2023 18:32:19 +0200
Message-Id: <20230424163219.9250-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2096; i=jack@suse.cz; h=from:subject; bh=hWzS2hw6KmLJ8Mphy0aCyGsPmlPQcBpzqtd6Camfujk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBkRq8BRpzEYYmR7dYi1+8dqy76UFS/unv6ZLQLegIW PXjcXTGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZEavAQAKCRCcnaoHP2RA2YveCA Cc8nQIKD3zo9WZ8XzftlCd7JvZvrHE3OCOe0Uz946dvLLZgsGO92puJn9ztl+ucn3bhx2C2Ti+383D AGLyrz5xTH7Y+2BCEaLhTrKl6SBFZILeWccia9GyDzRuKId/cLr77MbApVytJhfmgaKNPGVKN7lshM EZnjsT2huqRQ+I723WButYkA7zAsVBs2S/QJZAPo4Hjl1S+FNSBqqyLz0LUZvpmYfDA2a1i00qXRlQ coH93HDkIal0fVCop9TWbxKroIWtkkFESwcAYLFuRe/MGf7r7inKYlPFJzxnOVKvdWBYLr9WNtX/JB 42yl4DdKTXQICrY8q0PdjmGEqdDByT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When inotify_freeing_mark() races with inotify_handle_inode_event() it
can happen that inotify_handle_inode_event() sees that i_mark->wd got
already reset to -1 and reports this value to userspace which can
confuse the inotify listener. Avoid the problem by validating that wd is
sensible (and pretend the mark got removed before the event got
generated otherwise).

CC: stable@vger.kernel.org
Fixes: 7e790dd5fc93 ("inotify: fix error paths in inotify_update_watch")
Reported-by: syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/notify/inotify/inotify_fsnotify.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

I plan to merge this fix through my tree.

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 49cfe2ae6d23..f86d12790cb1 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -65,7 +65,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
 	struct fsnotify_event *fsn_event;
 	struct fsnotify_group *group = inode_mark->group;
 	int ret;
-	int len = 0;
+	int len = 0, wd;
 	int alloc_len = sizeof(struct inotify_event_info);
 	struct mem_cgroup *old_memcg;
 
@@ -80,6 +80,13 @@ int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
 	i_mark = container_of(inode_mark, struct inotify_inode_mark,
 			      fsn_mark);
 
+	/*
+	 * We can be racing with mark being detached. Don't report event with
+ 	 * invalid wd.
+	 */
+	wd = READ_ONCE(i_mark->wd);
+	if (wd == -1)
+		return 0;
 	/*
 	 * Whoever is interested in the event, pays for the allocation. Do not
 	 * trigger OOM killer in the target monitoring memcg as it may have
@@ -110,7 +117,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
 	fsn_event = &event->fse;
 	fsnotify_init_event(fsn_event);
 	event->mask = mask;
-	event->wd = i_mark->wd;
+	event->wd = wd;
 	event->sync_cookie = cookie;
 	event->name_len = len;
 	if (len)
-- 
2.35.3


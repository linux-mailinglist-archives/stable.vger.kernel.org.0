Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78512541329
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356001AbiFGT4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357022AbiFGTyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC95814BE;
        Tue,  7 Jun 2022 11:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB18B8237C;
        Tue,  7 Jun 2022 18:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4370CC36B00;
        Tue,  7 Jun 2022 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626207;
        bh=bf3A8Tav4GLThsLGs2hokuDRjuGzvnUBNsYxG+5a7Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrm5v4uekxasBgxEA//cehPKcI9fYVNp0334doGa02pTEWRcc7kGrJY+l90PRfa6I
         mCFD+/HUCfe2KfecsPMUKDcIS8Qi8sstRcaA8TMizCmEEsX8Rwn2YVuo9XYq4EDbRQ
         vBchGOBSBcK4W9txXrNbXUoMqLKssVeF0X6W3IUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 293/772] fsnotify: fix wrong lockdep annotations
Date:   Tue,  7 Jun 2022 18:58:05 +0200
Message-Id: <20220607164957.657625529@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 623af4f538b5df9b416e1b82f720af7371b4c771 ]

Commit 6960b0d909cd ("fsnotify: change locking order") changed some
of the mark_mutex locks in direct reclaim path to use:
  mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);

This change is explained:
 "...It uses nested locking to avoid deadlock in case we do the final
  iput() on an inode which still holds marks and thus would take the
  mutex again when calling fsnotify_inode_delete() in destroy_inode()."

The problem is that the mutex_lock_nested() is not a nested lock at
all. In fact, it has the opposite effect of preventing lockdep from
warning about a very possible deadlock.

Due to these wrong annotations, a deadlock that was introduced with
nfsd filecache in kernel v5.4 went unnoticed in v5.4.y for over two
years until it was reported recently by Khazhismel Kumykov, only to
find out that the deadlock was already fixed in kernel v5.5.

Fix the wrong lockdep annotations.

Cc: Khazhismel Kumykov <khazhy@google.com>
Fixes: 6960b0d909cd ("fsnotify: change locking order")
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Link: https://lore.kernel.org/r/20220422120327.3459282-4-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/mark.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 9007d6affff3..b42629d2fc1c 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -452,7 +452,7 @@ void fsnotify_free_mark(struct fsnotify_mark *mark)
 void fsnotify_destroy_mark(struct fsnotify_mark *mark,
 			   struct fsnotify_group *group)
 {
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+	mutex_lock(&group->mark_mutex);
 	fsnotify_detach_mark(mark);
 	mutex_unlock(&group->mark_mutex);
 	fsnotify_free_mark(mark);
@@ -770,7 +770,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group,
 	 * move marks to free to to_free list in one go and then free marks in
 	 * to_free list one by one.
 	 */
-	mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
 		if (mark->connector->type == obj_type)
 			list_move(&mark->g_list, &to_free);
@@ -779,7 +779,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group,
 
 clear:
 	while (1) {
-		mutex_lock_nested(&group->mark_mutex, SINGLE_DEPTH_NESTING);
+		mutex_lock(&group->mark_mutex);
 		if (list_empty(head)) {
 			mutex_unlock(&group->mark_mutex);
 			break;
-- 
2.35.1




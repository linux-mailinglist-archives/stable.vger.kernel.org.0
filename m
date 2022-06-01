Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6953A8B5
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355156AbiFAOLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243688AbiFAOJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF47CFD01;
        Wed,  1 Jun 2022 07:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F574B81AF7;
        Wed,  1 Jun 2022 13:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11912C385A5;
        Wed,  1 Jun 2022 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091772;
        bh=SvxtK91i3xQESf6tbSBGHp7J+Iwy+arLxPKjfKCQuOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxezu5f4IBcWrsDUXlDTBSF7d51XPHuJtZa+q7kpqztFiyvt/Mrtrowf2RdHoD0Tf
         JgS0t1IxU8zEeuxEFbrXVw4snK4aWp/jkKZzTDjSm17LsDmM9EEGT9XanMutTaARCJ
         wESv3p2O7bLMph2MEuaTHTcL4N4YApDL1qvDLMNV9r0D7Z5S8IX85HRYYYOUif/EKB
         9n5CRcNWnyXT/l1AxF30VehFB5etOpSc8DBOfniCoZ2D5ywuctH40vfneQqtv9c/sR
         9kv708DUu0JhK4cHWp0jEeI290t/rJP6raaAxJqDHDMddzvplRglP+NkuPTMILBPuo
         twS+AVPcUjQSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@openvz.org>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 43/48] fanotify: fix incorrect fmode_t casts
Date:   Wed,  1 Jun 2022 09:54:16 -0400
Message-Id: <20220601135421.2003328-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Vasily Averin <vvs@openvz.org>

[ Upstream commit dccd855771b37820b6d976a99729c88259549f85 ]

Fixes sparce warnings:
fs/notify/fanotify/fanotify_user.c:267:63: sparse:
 warning: restricted fmode_t degrades to integer
fs/notify/fanotify/fanotify_user.c:1351:28: sparse:
 warning: restricted fmode_t degrades to integer

FMODE_NONTIFY have bitwise fmode_t type and requires __force attribute
for any casts.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/9adfd6ac-1b89-791e-796b-49ada3293985@openvz.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index f2a1947ec5ee..ead37db01ab5 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -264,7 +264,7 @@ static int create_fd(struct fsnotify_group *group, struct path *path,
 	 * originally opened O_WRONLY.
 	 */
 	new_file = dentry_open(path,
-			       group->fanotify_data.f_flags | FMODE_NONOTIFY,
+			       group->fanotify_data.f_flags | __FMODE_NONOTIFY,
 			       current_cred());
 	if (IS_ERR(new_file)) {
 		/*
@@ -1329,7 +1329,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	    (!(fid_mode & FAN_REPORT_NAME) || !(fid_mode & FAN_REPORT_FID)))
 		return -EINVAL;
 
-	f_flags = O_RDWR | FMODE_NONOTIFY;
+	f_flags = O_RDWR | __FMODE_NONOTIFY;
 	if (flags & FAN_CLOEXEC)
 		f_flags |= O_CLOEXEC;
 	if (flags & FAN_NONBLOCK)
-- 
2.35.1


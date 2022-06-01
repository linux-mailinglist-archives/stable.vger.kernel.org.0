Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082DF53A6D5
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353685AbiFANzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353739AbiFANzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:55:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D0E8A31E;
        Wed,  1 Jun 2022 06:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B113B81AEA;
        Wed,  1 Jun 2022 13:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D61C3411D;
        Wed,  1 Jun 2022 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091651;
        bh=dsPytRuScUu0MpZ3yhZ+4QHzYxtIjhaCZwMQMNhAK7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlWa+FlloHYUoMnbm2o9O2/DtH1iryQVpIN5f5yUUbtytu6f4u67Ll5t5hsgJcaVz
         9jEhp7nWlQeDu5wSdbaEHlCseVSiV860I5z5nenrdM87dOwYVTn1r2fdKNPVjUeCZ6
         tnorO6v6LNzOk4IU38ogGD368AtEaFzw/mMKLfu6vjJTkvpxiA6Yxj+tUPxjZn16de
         xDr+/nYv/IivW0IZ+RX29asl7KsuoNcP11B6DbFacc3Sx7iLarfPwDllpdwSjgt0kb
         RrE8KuGkJcNnwNTC0cFVlnwZ+SKOa+N0IUASc6eRKCrxCKUiw4DeCYy22RO+oatMfj
         pUDnmVBmeZR0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@openvz.org>,
        Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 44/49] fanotify: fix incorrect fmode_t casts
Date:   Wed,  1 Jun 2022 09:52:08 -0400
Message-Id: <20220601135214.2002647-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
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
index a792e21c5309..16d8fc84713a 100644
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
@@ -1348,7 +1348,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	    (!(fid_mode & FAN_REPORT_NAME) || !(fid_mode & FAN_REPORT_FID)))
 		return -EINVAL;
 
-	f_flags = O_RDWR | FMODE_NONOTIFY;
+	f_flags = O_RDWR | __FMODE_NONOTIFY;
 	if (flags & FAN_CLOEXEC)
 		f_flags |= O_CLOEXEC;
 	if (flags & FAN_NONBLOCK)
-- 
2.35.1


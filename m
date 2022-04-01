Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249354EF49D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349741AbiDAO5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352588AbiDAOvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:51:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26652B4481;
        Fri,  1 Apr 2022 07:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DDEB824FD;
        Fri,  1 Apr 2022 14:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93063C2BBE4;
        Fri,  1 Apr 2022 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824114;
        bh=WK7tB+5PUmSKJ5UKAfBqMVxWt6Hj85EBkF01L8UeFSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8Cv9XFfjUdF95kumtAYFJeJAKMNCmHZSwHnF8Wc7kQuP2aSpNINs0ihNmVfjaHky
         uHk1N59NQQ4TKqH+s34XebLTKUttya0G2hhPgMXfzvXHjCvnQCeky8dYLkwcZzdycu
         EGiPTNTkLPPf9nV5H8pvYQBk2QGaxMLER42zhA81j7s/LumWvfS4AE98p3lv4M7nio
         atUG79ssW9KPnssTMSGLkO/fwTmjBagk9M7n0B92lB3S4P3PiHE+tP6ybOkcu3GH9z
         ZLbJWcF6GTBqXDpeRlaCnox5SE5g9NLHUF9mQxNrq/w3YbwQ018esACMFl26+rKNG3
         JMsQKHUod8AVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 95/98] ceph: fix memory leak in ceph_readdir when note_last_dentry returns error
Date:   Fri,  1 Apr 2022 10:37:39 -0400
Message-Id: <20220401143742.1952163-95-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit f639d9867eea647005dc824e0e24f39ffc50d4e4 ]

Reset the last_readdir at the same time, and add a comment explaining
why we don't free last_readdir when dir_emit returns false.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 133dbd9338e7..d91fa53e12b3 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -478,8 +478,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					2 : (fpos_off(rde->offset) + 1);
 			err = note_last_dentry(dfi, rde->name, rde->name_len,
 					       next_offset);
-			if (err)
+			if (err) {
+				ceph_mdsc_put_request(dfi->last_readdir);
+				dfi->last_readdir = NULL;
 				return err;
+			}
 		} else if (req->r_reply_info.dir_end) {
 			dfi->next_offset = 2;
 			/* keep last name */
@@ -520,6 +523,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		if (!dir_emit(ctx, rde->name, rde->name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
+			/*
+			 * NOTE: Here no need to put the 'dfi->last_readdir',
+			 * because when dir_emit stops us it's most likely
+			 * doesn't have enough memory, etc. So for next readdir
+			 * it will continue.
+			 */
 			dout("filldir stopping us...\n");
 			return 0;
 		}
-- 
2.34.1


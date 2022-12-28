Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB514657AEC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiL1PQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiL1PQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:16:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A566F10BF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40EF26155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53710C433D2;
        Wed, 28 Dec 2022 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240579;
        bh=Jd8K+jkkZkbgbn3LMA0FQ8m7KSnhp/xrdIKxgjwQKow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RagC89GbmmpxhYat1jht22WDDc4WHL7gUhyVKPotTRcgyCsRiCoVZF8ArkFIQ0ZNY
         vtCvztfl7vt6tcUh3n99iDlConyxHBKYnBYXx5EFAeuahixnI6LrE4hsFVE1HkWEYT
         cN+yydIe9y3za7bn5qy4MvHe3K9AI2zLp6w/dGB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0177/1073] lockd: set other missing fields when unlocking files
Date:   Wed, 28 Dec 2022 15:29:25 +0100
Message-Id: <20221228144332.817979687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 18ebd35b61b4693a0ddc270b6d4f18def232e770 ]

vfs_lock_file() expects the struct file_lock to be fully initialised by
the caller. Re-exported NFSv3 has been seen to Oops if the fl_file field
is NULL.

Fixes: aec158242b87 ("lockd: set fl_owner when unlocking files")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216582
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index e1c4617de771..3515f17eaf3f 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -176,7 +176,7 @@ nlm_delete_file(struct nlm_file *file)
 	}
 }
 
-static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
+static int nlm_unlock_files(struct nlm_file *file, const struct file_lock *fl)
 {
 	struct file_lock lock;
 
@@ -184,12 +184,15 @@ static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-	lock.fl_owner = owner;
-	if (file->f_file[O_RDONLY] &&
-	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
+	lock.fl_owner = fl->fl_owner;
+	lock.fl_pid   = fl->fl_pid;
+	lock.fl_flags = FL_POSIX;
+
+	lock.fl_file = file->f_file[O_RDONLY];
+	if (lock.fl_file && vfs_lock_file(lock.fl_file, F_SETLK, &lock, NULL))
 		goto out_err;
-	if (file->f_file[O_WRONLY] &&
-	    vfs_lock_file(file->f_file[O_WRONLY], F_SETLK, &lock, NULL))
+	lock.fl_file = file->f_file[O_WRONLY];
+	if (lock.fl_file && vfs_lock_file(lock.fl_file, F_SETLK, &lock, NULL))
 		goto out_err;
 	return 0;
 out_err:
@@ -226,7 +229,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 		if (match(lockhost, host)) {
 
 			spin_unlock(&flctx->flc_lock);
-			if (nlm_unlock_files(file, fl->fl_owner))
+			if (nlm_unlock_files(file, fl))
 				return 1;
 			goto again;
 		}
-- 
2.35.1




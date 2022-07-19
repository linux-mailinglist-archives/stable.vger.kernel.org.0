Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F36579C41
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbiGSMhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbiGSMhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:37:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9127165;
        Tue, 19 Jul 2022 05:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10A8DB81B21;
        Tue, 19 Jul 2022 12:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765AAC341C6;
        Tue, 19 Jul 2022 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232859;
        bh=JriZhhJjPKNaYLWd2CCG/ku0GwfO97kleLtUwigctRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY2yGBelRiyxMiuhIj1LKjj7Vf2hjbrEtoq6FnnLJIp/yn1phVd/ZEdzvLNqCQa6r
         OEgSt0I/PLgGOj8SSNJL8hZibnMG+y8NxmyBiSXJ8Rb+0QpambkK4zhlVVurwdMVTK
         otCY+BiSWl+ll6ZjVpb7RbPeUItnQtMSkTMYZfhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/167] lockd: set fl_owner when unlocking files
Date:   Tue, 19 Jul 2022 13:53:23 +0200
Message-Id: <20220719114703.370955571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit aec158242b87a43d83322e99bc71ab4428e5ab79 ]

Unlocking a POSIX lock on an inode with vfs_lock_file only works if
the owner matches. Ensure we set it in the request.

Cc: J. Bruce Fields <bfields@fieldses.org>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 0a22a2faf552..b2f277727469 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -176,7 +176,7 @@ nlm_delete_file(struct nlm_file *file)
 	}
 }
 
-static int nlm_unlock_files(struct nlm_file *file)
+static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
 {
 	struct file_lock lock;
 
@@ -184,6 +184,7 @@ static int nlm_unlock_files(struct nlm_file *file)
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
+	lock.fl_owner = owner;
 	if (file->f_file[O_RDONLY] &&
 	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
 		goto out_err;
@@ -225,7 +226,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 		if (match(lockhost, host)) {
 
 			spin_unlock(&flctx->flc_lock);
-			if (nlm_unlock_files(file))
+			if (nlm_unlock_files(file, fl->fl_owner))
 				return 1;
 			goto again;
 		}
-- 
2.35.1




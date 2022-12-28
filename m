Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B446579D5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiL1PFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiL1PFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D556B13D60
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F93EB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41CCC433D2;
        Wed, 28 Dec 2022 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239912;
        bh=Zw2Qby8m7WjbAf0R9AFaJsdYj5Bdka2UBKP7EQwATxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/4FVYTyug5tUzV6sdJkXkOo4RiOIJVbEmOIqg4o7i/c66PiMG+7sVmD/18LZaSXG
         +Newaze5OHuwahTUoCKpf58/P7gI/XHrv9t9XWxCqH3j3676uOsipo3hGhKA7CXYW1
         sAl3vpWbfUut1gmzXZjdB4dWGpR38FwlS3i3BIgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0093/1073] ovl: remove privs in ovl_fallocate()
Date:   Wed, 28 Dec 2022 15:28:01 +0100
Message-Id: <20221228144330.577932810@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 23a8ce16419a3066829ad4a8b7032a75817af65b ]

Underlying fs doesn't remove privs because fallocate is called with
privileged mounter credentials.

This fixes some failure in fstests generic/683..687.

Fixes: aab8848cee5e ("ovl: add ovl_fallocate()")
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 362a4eed92b5..a34f8042724c 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -517,9 +517,16 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	const struct cred *old_cred;
 	int ret;
 
+	inode_lock(inode);
+	/* Update mode */
+	ovl_copyattr(inode);
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
 	ret = ovl_real_fdget(file, &real);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = vfs_fallocate(real.file, mode, offset, len);
@@ -530,6 +537,9 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 
 	fdput(real);
 
+out_unlock:
+	inode_unlock(inode);
+
 	return ret;
 }
 
-- 
2.35.1




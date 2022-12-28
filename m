Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB4C6579D2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiL1PFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiL1PFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32AD13D56
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93414B816E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01841C433EF;
        Wed, 28 Dec 2022 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239904;
        bh=Xp1YokSJ9Gw+G79YFW3oEKOgvxy5p1aLvCDTGPe0NSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klZsAa9YzVOC7rFIAZ+waObjF2jxMz/X6aRu2yiZNTYkeCR6QpJyIuXyUAbVKeAQK
         NdwZvFAZ1LG1dRAOceyej9MdfavtLM3NYz+nqAB0CH8s4la+s2qI6S0w1IAql/apop
         kOe6UpNDjOBvNZGrOBrKPN3+jX5A0GAqPG4kCfDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0092/1073] ovl: remove privs in ovl_copyfile()
Date:   Wed, 28 Dec 2022 15:28:00 +0100
Message-Id: <20221228144330.552593666@linuxfoundation.org>
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

[ Upstream commit b306e90ffabdaa7e3b3350dbcd19b7663e71ab17 ]

Underlying fs doesn't remove privs because copy_range/remap_range are
called with privileged mounter credentials.

This fixes some failures in fstest generic/673.

Fixes: 8ede205541ff ("ovl: add reflink/copyfile/dedup support")
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index daff601b5c41..362a4eed92b5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -567,14 +567,23 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	const struct cred *old_cred;
 	loff_t ret;
 
+	inode_lock(inode_out);
+	if (op != OVL_DEDUPE) {
+		/* Update mode */
+		ovl_copyattr(inode_out);
+		ret = file_remove_privs(file_out);
+		if (ret)
+			goto out_unlock;
+	}
+
 	ret = ovl_real_fdget(file_out, &real_out);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	ret = ovl_real_fdget(file_in, &real_in);
 	if (ret) {
 		fdput(real_out);
-		return ret;
+		goto out_unlock;
 	}
 
 	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
@@ -603,6 +612,9 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	fdput(real_in);
 	fdput(real_out);
 
+out_unlock:
+	inode_unlock(inode_out);
+
 	return ret;
 }
 
-- 
2.35.1




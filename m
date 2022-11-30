Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EEC63DE04
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiK3SdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiK3Sc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA9A23EAD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83E74B81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21E1C433B5;
        Wed, 30 Nov 2022 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833167;
        bh=373p602+sBVhWfewHbYRoY/QYfL6WsBYwAePe77wnv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLDNMAK3CXzJB5da/TxF32lPpaafiv3mkY4H3odX9RPjdxX8+3pUMXGWiwKu/dXUc
         5jc+E68Iobzsjp4Wu2K9PCjKGRSD0lev7kFAext4jaQ7M3jxEbf7XeRNpLbt/GSUip
         vuSoGSoyN2kELsh4ASOtk5VQMgUGEN+/cBWPPrvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/206] cifs: Fix connections leak when tlink setup failed
Date:   Wed, 30 Nov 2022 19:21:03 +0100
Message-Id: <20221130180533.282963317@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 1dcdf5f5b2137185cbdd5385f29949ab3da4f00c ]

If the tlink setup failed, lost to put the connections, then
the module refcnt leak since the cifsd kthread not exit.

Also leak the fscache info, and for next mount with fsc, it will
print the follow errors:
  CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)

Let's check the result of tlink setup, and do some cleanup.

Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 902eb8a5afd2..839059b8a9c9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3550,9 +3550,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
 
 out:
-	free_xid(mnt_ctx.xid);
 	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
 	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
@@ -3579,8 +3583,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
 	free_xid(mnt_ctx.xid);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	return rc;
 
 error:
 	mount_put_conns(&mnt_ctx);
-- 
2.35.1




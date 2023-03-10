Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B766B49FD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbjCJPRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjCJPRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:17:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294AD74328
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F7CBCE2943
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BAC433EF;
        Fri, 10 Mar 2023 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460845;
        bh=UM6GJLmQHU3qxKCvnmrD0qJHkaWoPMtnPUramyjN9sE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ws5lA5rS4mUn/3RvNvxZJ8JJ9TBv8srIiEXV0gDK66GBeMliOdYvU4NRx07CxRAZL
         u3AUm/vRvxGJDuU/fmThJMcdpmMivW/uLMCROhHtFdQqa44lv56U24t8726CiqOM+I
         iUMf0dvxOVMBa5iwQCdgnmfojDQc8KgIitRKrng4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 443/529] ubifs: Rectify space budget for ubifs_xrename()
Date:   Fri, 10 Mar 2023 14:39:46 +0100
Message-Id: <20230310133825.444239312@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 1b2ba09060e41adb356b9ae58ef94a7390928004 ]

There is no space budget for ubifs_xrename(). It may let
make_reservation() return with -ENOSPC, which could turn
ubifs to read-only mode in do_writepage() process.
Fix it by adding space budget for ubifs_xrename().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216569
Fixes: 9ec64962afb170 ("ubifs: Implement RENAME_EXCHANGE")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 7dceca1be9b5d..15b5664fd5c93 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1530,6 +1530,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1555,6 +1559,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
-- 
2.39.2




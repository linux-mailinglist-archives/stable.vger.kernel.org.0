Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133976B4360
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjCJOOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjCJONr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:13:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5176B1194F3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F03BCB822BA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63828C433D2;
        Fri, 10 Mar 2023 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457243;
        bh=cS+DtdsVu+fYrOFvYk2bwSQL9yt3KSAJFFbJxu8sRaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TflovSLSbuPCDfdGny8FHVNTYsdqKGfI8GYin+zvB12bgW1nAblCnZ3sFnc0nkaEK
         IpeeY1rh0oQFGRRkLJsFDMOhu3XgXpjP5yhq8fDGVBH1TIw+cAgMFyttgevRU03WNu
         8sl9vQ8FpvWiCZaFJHs9SJS7wqf7jMl8QQFaAdpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/200] ubifs: Rectify space budget for ubifs_xrename()
Date:   Fri, 10 Mar 2023 14:37:15 +0100
Message-Id: <20230310133717.907059657@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index aaff3f3f0aa3b..94634b872e382 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1576,6 +1576,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1601,6 +1605,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
-- 
2.39.2




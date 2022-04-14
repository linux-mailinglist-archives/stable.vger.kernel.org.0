Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9761D50104E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiDNNhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbiDNN2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2A9AC077;
        Thu, 14 Apr 2022 06:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50E27619FD;
        Thu, 14 Apr 2022 13:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF9DC385A1;
        Thu, 14 Apr 2022 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942558;
        bh=4qYlqX1bEJoR3QcQAW1sTb116QDn2HpZAFF9pvsTW6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXZ7NaiTVX7nJ5LLQxSpZk0COjvPAl5VQLRcwmk1jTFxhP1ndiIa45mrrf6nJBxQd
         Iy2VOitNxzNQL7DAzLigkmtjzg4uNMI/ZOdUjd/AvHXtuf6PhpM3TnbF/ZA4kKqlHe
         H8BxkSly3B/syyx2OL2UifrXyLRXABGkN1xnEM0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+46f5c25af73eb8330eb6@syzkaller.appspotmail.com
Subject: [PATCH 4.19 179/338] jfs: fix divide error in dbNextAG
Date:   Thu, 14 Apr 2022 15:11:22 +0200
Message-Id: <20220414110843.993017879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 2cc7cc01c15f57d056318c33705647f87dcd4aab ]

Syzbot reported divide error in dbNextAG(). The problem was in missing
validation check for malicious image.

Syzbot crafted an image with bmp->db_numag equal to 0. There wasn't any
validation checks, but dbNextAG() blindly use bmp->db_numag in divide
expression

Fix it by validating bmp->db_numag in dbMount() and return an error if
image is malicious

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+46f5c25af73eb8330eb6@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 687b07b9b4f6..f05805a10a50 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -161,6 +161,7 @@ static const s8 budtab[256] = {
  *	0	- success
  *	-ENOMEM	- insufficient memory
  *	-EIO	- i/o error
+ *	-EINVAL - wrong bmap data
  */
 int dbMount(struct inode *ipbmap)
 {
@@ -192,6 +193,12 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_nfree = le64_to_cpu(dbmp_le->dn_nfree);
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
 	bmp->db_numag = le32_to_cpu(dbmp_le->dn_numag);
+	if (!bmp->db_numag) {
+		release_metapage(mp);
+		kfree(bmp);
+		return -EINVAL;
+	}
+
 	bmp->db_maxlevel = le32_to_cpu(dbmp_le->dn_maxlevel);
 	bmp->db_maxag = le32_to_cpu(dbmp_le->dn_maxag);
 	bmp->db_agpref = le32_to_cpu(dbmp_le->dn_agpref);
-- 
2.34.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6B505911
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245414AbiDROOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343628AbiDROMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:12:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1525381B3;
        Mon, 18 Apr 2022 06:11:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51BB9B80EC0;
        Mon, 18 Apr 2022 13:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950F2C385A1;
        Mon, 18 Apr 2022 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287517;
        bh=G1cCzSEmSyEJgD7avDuvFKb78yXZro2e0oLgp9BKbiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGvTkVxvVZ/ktyKkYsI3czHVVkvKoE9zM5sJ6HHxDsyaaiRFveRWTb1eG2di04o2Q
         w1SJyDh/CUCE0YkAKPl8aHA5+THIUAAPP72XISBLOr36OcFTAG0WGfnRUgTayiffV3
         iwJgXHPjcv3qtqshp7gbXUR2w/1tmox+v3Aw1s1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TCS Robot <tcs_robot@tencent.com>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 186/218] jfs: prevent NULL deref in diFree
Date:   Mon, 18 Apr 2022 14:14:12 +0200
Message-Id: <20220418121206.448774066@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit a53046291020ec41e09181396c1e829287b48d47 ]

Add validation check for JFS_IP(ipimap)->i_imap to prevent a NULL deref
in diFree since diFree uses it without do any validations.
When function jfs_mount calls diMount to initialize fileset inode
allocation map, it can fail and JFS_IP(ipimap)->i_imap won't be
initialized. Then it calls diFreeSpecial to close fileset inode allocation
map inode and it will flow into jfs_evict_inode. Function jfs_evict_inode
just validates JFS_SBI(inode->i_sb)->ipimap, then calls diFree. diFree use
JFS_IP(ipimap)->i_imap directly, then it will cause a NULL deref.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 87b41edc800d..68779cc3609a 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -156,12 +156,13 @@ void jfs_evict_inode(struct inode *inode)
 		dquot_initialize(inode);
 
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
+			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
 			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			if (JFS_SBI(inode->i_sb)->ipimap)
+			if (ipimap && JFS_IP(ipimap)->i_imap)
 				diFree(inode);
 
 			/*
-- 
2.35.1




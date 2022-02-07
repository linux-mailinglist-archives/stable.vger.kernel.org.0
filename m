Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB94ABA6C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383695AbiBGLXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378374AbiBGLPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0748CC03FEE4;
        Mon,  7 Feb 2022 03:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 125F661261;
        Mon,  7 Feb 2022 11:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1385C004E1;
        Mon,  7 Feb 2022 11:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232527;
        bh=JMahfiX//lp0cOousyhIrX++kALvABEYKu4qvkRO6Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TndUlk9THPEgzMOO0/6VyRSZSFDPeuPXzB0HK5wJ/ulKNCs2q0VLw6yH7g67z298y
         FYfMwmd6GXhzeFTnM6yeNfglMyLnOp4WsCP3m7Fz9bit2PANP/8RNmflQ/2NvNQQ/+
         A2MC10wf63yfg7kW9oXfGyl+HXA/7/IbyY99YrEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/86] NFS: Ensure the server has an up to date ctime before renaming
Date:   Mon,  7 Feb 2022 12:06:02 +0100
Message-Id: <20220207103758.813501892@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6ff9d99bb88faebf134ca668842349d9718e5464 ]

Renaming a file is required by POSIX to update the file ctime, so
ensure that the file data is synced to disk so that we don't clobber the
updated ctime by writing back after creating the hard link.

Fixes: f2c2c552f119 ("NFS: Move delegation recall into the NFSv4 callback for rename_setup()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2123,6 +2123,8 @@ int nfs_rename(struct inode *old_dir, st
 		}
 	}
 
+	if (S_ISREG(old_inode->i_mode))
+		nfs_sync_inode(old_inode);
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry, NULL);
 	if (IS_ERR(task)) {
 		error = PTR_ERR(task);



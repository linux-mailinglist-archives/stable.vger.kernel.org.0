Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F55E60FE2B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbiJ0RCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiJ0RCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:02:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EE31911CB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5338B824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364D1C433D6;
        Thu, 27 Oct 2022 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890164;
        bh=wUY3n2x/16NSoTYzIxCIyCgWXzKPhDdcJNSiSw7KqeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWLiqa3a0ZFESqFrILmD82h3XdUIBEDkvuLmGflzVAdgXo+naQp5Q9OY5tJBy1JwO
         T2l+DrJuTNQdH9EvIy0hIB1+odMfbXYAw7JnGPoB09n/POAwGMVaxkExT8RbD2104f
         YiK9sTMWOztbRvri/+iMHqMO2EY3rMsPqyj/HnH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/79] cifs: Fix xid leak in cifs_create()
Date:   Thu, 27 Oct 2022 18:55:44 +0200
Message-Id: <20221027165056.441284837@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit fee0fb1f15054bb6a0ede452acb42da5bef4d587 ]

If the cifs already shutdown, we should free the xid before return,
otherwise, the xid will be leaked.

Fixes: 087f757b0129 ("cifs: add shutdown support")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6e8e7cc26ae2..83c929dd6ed5 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -538,8 +538,10 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
+		rc = -EIO;
+		goto out_free_xid;
+	}
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
-- 
2.35.1




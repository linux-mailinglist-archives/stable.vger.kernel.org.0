Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A351C24BB90
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgHTJuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbgHTJul (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:50:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03992075E;
        Thu, 20 Aug 2020 09:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917041;
        bh=cecQAWHLmwsCCrinzA06frVhhV1249x+4mNIPD1Sj6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSm18AkyNWid1pty2PZvZORfT8GRNO7Df0o2lgzQHcjmiOZ/FLC49pe2UuUqlnT7v
         BoHpVaRAnsoY0/6Y9NGwDFCIDNV6gGaE3QifHOavAM8if4AVvSOWwvIw7WuB3Q/Ziy
         HTzz19mUQ0Esbxhu2BYMXz1a3/jAax+JC/n5Y0hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/152] fs/ufs: avoid potential u32 multiplication overflow
Date:   Thu, 20 Aug 2020 11:21:42 +0200
Message-Id: <20200820091600.725717478@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 88b2e9b06381551b707d980627ad0591191f7a2d ]

The 64 bit ino is being compared to the product of two u32 values,
however, the multiplication is being performed using a 32 bit multiply so
there is a potential of an overflow.  To be fully safe, cast uspi->s_ncg
to a u64 to ensure a 64 bit multiplication occurs to avoid any chance of
overflow.

Fixes: f3e2a520f5fb ("ufs: NFS support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Link: http://lkml.kernel.org/r/20200715170355.1081713-1-colin.king@canonical.com
Addresses-Coverity: ("Unintentional integer overflow")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 1da0be667409b..e3b69fb280e8c 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -101,7 +101,7 @@ static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 gene
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct inode *inode;
 
-	if (ino < UFS_ROOTINO || ino > uspi->s_ncg * uspi->s_ipg)
+	if (ino < UFS_ROOTINO || ino > (u64)uspi->s_ncg * uspi->s_ipg)
 		return ERR_PTR(-ESTALE);
 
 	inode = ufs_iget(sb, ino);
-- 
2.25.1




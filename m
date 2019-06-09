Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762883A9C6
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388111AbfFIRNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733029AbfFIQ6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802CE204EC;
        Sun,  9 Jun 2019 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099521;
        bh=JDcnCjSYLU5/raDYUcHQLOgeRSHp3V1XlDnyXDbSdBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfvdkNLoIt/SMmr85poezXVp0TQ4t1bNgU6jwHPNA6Fsjf9tfg4V9kQZfTRCwqVMg
         L9D8XdcCiDxNOW7oaf7EKYL9icI1hcWEcAkiLeR9rz0sWScl+QAEPD8MYKdax1tbMp
         hOlN1bpoRkF7yq/4MUDjAuDMnJ8ZpmaXrwM4+3zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 070/241] ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour
Date:   Sun,  9 Jun 2019 18:40:12 +0200
Message-Id: <20190609164149.793536295@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4e9036042fedaffcd868d7f7aa948756c48c637d ]

To choose whether to pick the GID from the old (16bit) or new (32bit)
field, we should check if the old gid field is set to 0xffff.  Mainline
checks the old *UID* field instead - cut'n'paste from the corresponding
code in ufs_get_inode_uid().

Fixes: 252e211e90ce
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 3f9463f8cf2fa..f877d5cadd981 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -228,7 +228,7 @@ ufs_get_inode_gid(struct super_block *sb, struct ufs_inode *inode)
 	case UFS_UID_44BSD:
 		return fs32_to_cpu(sb, inode->ui_u3.ui_44.ui_gid);
 	case UFS_UID_EFT:
-		if (inode->ui_u1.oldids.ui_suid == 0xFFFF)
+		if (inode->ui_u1.oldids.ui_sgid == 0xFFFF)
 			return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_gid);
 		/* Fall through */
 	default:
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54C028776
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbfEWTTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389859AbfEWTTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA59217D7;
        Thu, 23 May 2019 19:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639177;
        bh=dmdkHKAlomDeyTm+9zna1RJf7joT+IgtoQOEjI8u2SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2OJHfRARJBMWXBfcXVXu76po3SzK0/PYM3bJVfCmBHbk8N/qqMypIUjfwksFff+p
         6Ut81reVKGPakotmctakFxt+5rqTDwG776l2wXt1N/gtnRzOEQ6rRZnLZ1IDbIRJ0s
         3JpWKYmBlvsSjBgi+hB88AoDqkNTMIb/rN9D6/VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/114] ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour
Date:   Thu, 23 May 2019 21:06:44 +0200
Message-Id: <20190523181740.484025455@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
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
index 1fd3011ea6236..7fd4802222b8c 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -229,7 +229,7 @@ ufs_get_inode_gid(struct super_block *sb, struct ufs_inode *inode)
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




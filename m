Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D922052E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfEPLlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfEPLlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:41:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482B52089E;
        Thu, 16 May 2019 11:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006903;
        bh=ULdJcaIXJ/b1m6G/QWYPKTXwbMt1qbvOUmLSCTNWUVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgMqmoNZYukJG0HdpuNNyfBF+92l41GYIcm/hTiywqSwgAHQhghVhjf81ATkqDgws
         /MouXtQyUfl9Dautl4F6NT3RPRs4xnqd1DOsq5qk2qnVblljUftzvdzMyx99DXcpX6
         5zFHTnOUjq+ROSElZ2WC33Q2LkvOi8ZJa++CUqZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 8/9] ufs: fix braino in ufs_get_inode_gid() for solaris UFS flavour
Date:   Thu, 16 May 2019 07:41:32 -0400
Message-Id: <20190516114134.9146-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114134.9146-1-sashal@kernel.org>
References: <20190516114134.9146-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

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
index 398019fb14481..9c4fb1fc0822a 100644
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


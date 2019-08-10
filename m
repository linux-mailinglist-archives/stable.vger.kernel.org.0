Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0583088DA9
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfHJUoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:44:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54872 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726805AbfHJUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDW-00053m-R0; Sat, 10 Aug 2019 21:43:58 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003iI-Lu; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.999591096@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 120/157] ufs: fix braino in ufs_get_inode_gid() for
 solaris UFS flavour
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4e9036042fedaffcd868d7f7aa948756c48c637d upstream.

To choose whether to pick the GID from the old (16bit) or new (32bit)
field, we should check if the old gid field is set to 0xffff.  Mainline
checks the old *UID* field instead - cut'n'paste from the corresponding
code in ufs_get_inode_uid().

Fixes: 252e211e90ce
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ufs/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -228,7 +228,7 @@ ufs_get_inode_gid(struct super_block *sb
 	case UFS_UID_44BSD:
 		return fs32_to_cpu(sb, inode->ui_u3.ui_44.ui_gid);
 	case UFS_UID_EFT:
-		if (inode->ui_u1.oldids.ui_suid == 0xFFFF)
+		if (inode->ui_u1.oldids.ui_sgid == 0xFFFF)
 			return fs32_to_cpu(sb, inode->ui_u3.ui_sun.ui_gid);
 		/* Fall through */
 	default:


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CF260FE84
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiJ0RGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiJ0RF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A45198448
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E35EF623F4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05964C433D6;
        Thu, 27 Oct 2022 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890351;
        bh=9maBcr2K76svSN6LfWmaVSOvfaOzmErTYgaXuxKDQL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sb+KsELknVixGn8pMBEKc4K4f7YPkhRrLBNceIGZvYJ7JjzcoGqy0x1m+DZFR++pk
         T8MiB9amX495Y7ODNapUWH9mY1YuCMj54r6LN09JZrkoRQKX0YQe88C90/T145pSk5
         uAq2bZ5RYpv+yDDsmypwCRwKuIQ/dd12RGfsX71I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/79] cifs: Fix xid leak in cifs_flock()
Date:   Thu, 27 Oct 2022 18:55:48 +0200
Message-Id: <20221027165055.654970843@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

[ Upstream commit 575e079c782b9862ec2626403922d041a42e6ed6 ]

If not flock, before return -ENOLCK, should free the xid,
otherwise, the xid will be leaked.

Fixes: d0677992d2af ("cifs: add support for flock")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a648146e49cf..144064dc0d38 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1735,11 +1735,13 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 	struct cifsFileInfo *cfile;
 	__u32 type;
 
-	rc = -EACCES;
 	xid = get_xid();
 
-	if (!(fl->fl_flags & FL_FLOCK))
-		return -ENOLCK;
+	if (!(fl->fl_flags & FL_FLOCK)) {
+		rc = -ENOLCK;
+		free_xid(xid);
+		return rc;
+	}
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);
@@ -1758,8 +1760,9 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
 		 * if no lock or unlock then nothing to do since we do not
 		 * know what it is
 		 */
+		rc = -EOPNOTSUPP;
 		free_xid(xid);
-		return -EOPNOTSUPP;
+		return rc;
 	}
 
 	rc = cifs_setlk(file, fl, type, wait_flag, posix_lck, lock, unlock,
-- 
2.35.1




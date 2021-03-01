Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43924328AFE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239883AbhCAS1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239749AbhCASUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A50F865096;
        Mon,  1 Mar 2021 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619925;
        bh=IxLL7SEP8glw3sRQqtQ4DjUZlS6FwlZMJbJaPoo1dJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCKB1XqRjZaKVzu+FnpwuLA2Cc9SkV7gDRHNrwfUSxXQ/TpqVRUtAyJGz0AHyWKSt
         jrFr/VmaY8FlndJmdEtGWju90UD4Z7G8889kTy0I+1TrVbAU6MQrL290S8d+1BipDY
         tlnILKzNSveC6qJoesY7mAFff8LuuZ8VqZjhMlL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 631/663] f2fs: fix out-of-repair __setattr_copy()
Date:   Mon,  1 Mar 2021 17:14:39 +0100
Message-Id: <20210301161213.075531406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 2562515f0ad7342bde6456602c491b64c63fe950 upstream.

__setattr_copy() was copied from setattr_copy() in fs/attr.c, there is
two missing patches doesn't cover this inner function, fix it.

Commit 7fa294c8991c ("userns: Allow chown and setgid preservation")
Commit 23adbe12ef7d ("fs,userns: Change inode_capable to capable_wrt_inode_uidgid")

Fixes: fbfa2cc58d53 ("f2fs: add file operations")
Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -851,7 +851,8 @@ static void __setattr_copy(struct inode
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		if (!in_group_p(inode->i_gid) &&
+			!capable_wrt_inode_uidgid(inode, CAP_FSETID))
 			mode &= ~S_ISGID;
 		set_acl_inode(inode, mode);
 	}



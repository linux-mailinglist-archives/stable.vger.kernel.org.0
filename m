Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A039FEDA0
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfKPPpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfKPPph (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:45:37 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6379C20803;
        Sat, 16 Nov 2019 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919136;
        bh=EQZ7mfCriInnZRn9UMpQSDdMM3ZNFHm+aa73nZvvwtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcsCd2nCGCmj6jlLPaXo77aG6naZj9HT1pLLqYucqKX+t4jmyGpQQgrZjuUDUU75b
         1UO/aHmkdDqGgG4JYUNjYL96EFAj1CJqYid5yLjX8bpWZCQdRM3v1NpaKHI7zn2FLr
         5T0nK2W4k2sZayNIpknswcoIQ2esl5loHVwfKiac=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 160/237] hfs: update timestamp on truncate()
Date:   Sat, 16 Nov 2019 10:39:55 -0500
Message-Id: <20191116154113.7417-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit 8cd3cb5061730af085a3f9890a3352f162b4e20c ]

The vfs takes care of updating mtime on ftruncate(), but on truncate() it
must be done by the module.

Link: http://lkml.kernel.org/r/e1611eda2985b672ed2d8677350b4ad8c2d07e8a.1539316825.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a2dfa1b2a89c7..da243c84e93b0 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -642,6 +642,8 @@ int hfs_inode_setattr(struct dentry *dentry, struct iattr * attr)
 
 		truncate_setsize(inode, attr->ia_size);
 		hfs_file_truncate(inode);
+		inode->i_atime = inode->i_mtime = inode->i_ctime =
+						  current_time(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C660810BCEC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbfK0VCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731898AbfK0VCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB49215A5;
        Wed, 27 Nov 2019 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888549;
        bh=W6T0qxVUQejosUr+bj/+5xttfCFxqDgrSuXmTQbWXog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbhSmuKQxB+liV0fakzcz46cC9IEKCqC72QezjmzgNimS643ZZEk1nCIZHPQ2XZgA
         HYPinaPA7iccZgCVtU/8ys5Pd08UtJgZsd377/f/MBwbGqQ6cohElLD1B9WLl1laAY
         ESI3G4F2jp2pbrstb6pjWHxSxYnWljbJY7NF6Y6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" 
        <ernesto.mnd.fernandez@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 176/306] hfsplus: update timestamps on truncate()
Date:   Wed, 27 Nov 2019 21:30:26 +0100
Message-Id: <20191127203128.212013365@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit dc8844aada735890a6de109bef327f5df36a982e ]

The vfs takes care of updating ctime and mtime on ftruncate(), but on
truncate() it must be done by the module.

This patch can be tested with xfstests generic/313.

Link: http://lkml.kernel.org/r/9beb0913eea37288599e8e1b7cec8768fb52d1b8.1539316825.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 8e9427a42b819..d7ab9d8c4b674 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -261,6 +261,7 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 		truncate_setsize(inode, attr->ia_size);
 		hfsplus_file_truncate(inode);
+		inode->i_mtime = inode->i_ctime = current_time(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
2.20.1




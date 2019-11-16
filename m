Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05350FF0FB
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfKPQJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730390AbfKPPt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:59 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E1E20855;
        Sat, 16 Nov 2019 15:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919398;
        bh=gBTeW+pCyoMom3SAv8uExhGU7eCyM3+qFj3QzheXUr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDe07VVpk3hztuaIbHmodKd8VMKZ9Hhg1Vop+wWrbRWLV2CJAjNFxLUO8degtQq5R
         XjQyfgJxqKmRoWx31eyFqz1CceJY4kDKxZ2T7RNkfqSHT3YF8CMSss2Azw2fGaF67a
         ZYE7XgFUbZa+SJsbmy0jNEwT4ufHoABhMr+3KAIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 101/150] hfsplus: update timestamps on truncate()
Date:   Sat, 16 Nov 2019 10:46:39 -0500
Message-Id: <20191116154729.9573-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
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
index 190c60efbc998..5b31f4730ee9c 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -262,6 +262,7 @@ static int hfsplus_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 		truncate_setsize(inode, attr->ia_size);
 		hfsplus_file_truncate(inode);
+		inode->i_mtime = inode->i_ctime = current_time(inode);
 	}
 
 	setattr_copy(inode, attr);
-- 
2.20.1


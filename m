Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A8E107009
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfKVKqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbfKVKqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:46:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7ED602072D;
        Fri, 22 Nov 2019 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419578;
        bh=uddy0IJBcHg7Jm9rKBTSDP8OwXg59gNsk0H1n3osQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTl59JLcb0ij8Lwy3jCzZIftXFoeWgUP0bpv439wK1A4pNE/0ermp1YEfKw3wRCnD
         WtY65g+lhPqyCIF9K8ErGo8hdS9D8xy4/RFBB3XUYbbfrMfKzrTnQ1XoeY6Zq0T+qu
         VDpeUitu+IBq8ILgdWcpb343JZQjEFYOC4BLnV+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 158/222] f2fs: return correct errno in f2fs_gc
Date:   Fri, 22 Nov 2019 11:28:18 +0100
Message-Id: <20191122100914.086543232@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 61f7725aa148ee870436a29d3a24d5c00ab7e9af ]

This fixes overriding error number in f2fs_gc.

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 759056e776e50..b1d62003cda62 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -985,7 +985,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync)
 
 	put_gc_inode(&gc_list);
 
-	if (sync)
+	if (sync && !ret)
 		ret = sec_freed ? 0 : -EAGAIN;
 	return ret;
 }
-- 
2.20.1




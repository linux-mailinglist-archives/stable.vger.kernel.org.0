Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1CFA36F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfKMCJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:09:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfKMB7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B22022476;
        Wed, 13 Nov 2019 01:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610379;
        bh=uddy0IJBcHg7Jm9rKBTSDP8OwXg59gNsk0H1n3osQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN4dCd67G3A6mRPEwV9aI9Ql6yWOWtLYVcLZxvf0bNdoUFr6Icn6QPbrBm35FwDXD
         QuMXME34orwxcdxvGTMQwaRIB/L/9/8qbtl6mK+UHkRbh58kObRWx1Hi3vRH6lVot7
         +OCDBLcGPpiw7f70gPHBK122Z0YlV2X6aqx3pAW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 04/68] f2fs: return correct errno in f2fs_gc
Date:   Tue, 12 Nov 2019 20:58:28 -0500
Message-Id: <20191113015932.12655-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


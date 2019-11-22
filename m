Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7A106F12
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfKVK4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbfKVK4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2807C2073B;
        Fri, 22 Nov 2019 10:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420183;
        bh=AZovaWb7kUE5S+uJuZWRgFGbFjGvS0V6bJLQ2mcQLZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h30SwN6HjlVCBkFRHAqyy4dyRHZE+4xTAnwfGFsQjCgYt8f0Z+k+xGvCGAVGr+icm
         PTeUo0YzdFvOhl4K94YJglJ4vI9zrgEaTtuEqbnrUzAwQu6x0wG0/NBfevemX9MYG7
         r5zJexqg8Rc7pOYuJF8ksaeGFe2SfVPHVhG/tEi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/220] f2fs: return correct errno in f2fs_gc
Date:   Fri, 22 Nov 2019 11:26:26 +0100
Message-Id: <20191122100914.034146505@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index dd29a49143f54..8c4cb1eee10a6 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1244,7 +1244,7 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 
 	put_gc_inode(&gc_list);
 
-	if (sync)
+	if (sync && !ret)
 		ret = sec_freed ? 0 : -EAGAIN;
 	return ret;
 }
-- 
2.20.1




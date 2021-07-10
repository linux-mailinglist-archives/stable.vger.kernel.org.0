Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934D43C38E8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhGJX4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhGJXzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 254DE613D8;
        Sat, 10 Jul 2021 23:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961119;
        bh=05YVo86CiuBYiukcymadG4RezgYinaKalPBf36/aqGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxlkcotK9FlXr3cuv9xla1ZH326bFH8qcOcwYfQzmSmNsek78IcLFuxyUnLZxsWSl
         ys70SFsllznWxl8SjK0K8PA8kTh/ID+foVA/8ZoOp7ca+ihoKQfRiD46G1JzrT2mgZ
         yvpvVCRMEN6V3S0JH+uvWv0tS5zDy9Db1doCQzL6VVPlR5H+YgGouTdgnCfQT6XqyO
         4/yoI35tB5BlarlY4K9D3289ou54U4ABDBE3sDzT41kC8qKts8t1KaJsHg/vZGBpaV
         EROpBRCFUFDY1x9UNacOY0rQDHAifjLFxN/A2JOOZcVqgUOD3ijwVLzv7TA5jR23/I
         KhVup/f1wHsnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.19 12/22] orangefs: fix orangefs df output.
Date:   Sat, 10 Jul 2021 19:51:33 -0400
Message-Id: <20210710235143.3222129-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 0fdec1b3c9fbb5e856a40db5993c9eaf91c74a83 ]

Orangefs df output is whacky. Walt Ligon suggested this might fix it.
It seems way more in line with reality now...

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index dfaee90d30bd..524fd95173b3 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -195,7 +195,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2


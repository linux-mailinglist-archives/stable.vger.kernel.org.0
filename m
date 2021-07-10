Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813AD3C3835
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhGJXyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233352AbhGJXxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1ADC61184;
        Sat, 10 Jul 2021 23:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961047;
        bh=9sHeRwrUUh9yPtTPlC8N358xe2XQYAzu9ijcoIe1FJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbMT805UYGB/dXcyqiUY2xPhW4BFQvbLQMAnq8nNr8SPuqlU0HUqh4eoePoh+mdEE
         FVnNGpN6X3+cOXcnWN2lWUMX2YjJHsnrH8vOomdMxQx2M2DdYVxeYjjUnQlKxPnMDe
         XQTSotURZT9ZRZBKT2YdPh1bfxBQTcm+PrlEZnixL8p286CBKqwO3gWWqaon79eboI
         5Dxc27WQlG4tVd8UXuVzaPrT+5+uMlICixIHcDGqzbaxhWoKbov6GaM5aXHGsrM2dE
         dOVbn3KCPLExXN4ozNWdRGm21NT8XoTBKkGPmfIQTNd1Ql+0qRXLP4Tf9W111oLO50
         xUNCDOB+TidPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 5.10 22/37] orangefs: fix orangefs df output.
Date:   Sat, 10 Jul 2021 19:50:00 -0400
Message-Id: <20210710235016.3221124-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
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
index ee5efdc35cc1..2f2e430461b2 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -209,7 +209,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43093C389D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhGJXzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233491AbhGJXyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6A01613F2;
        Sat, 10 Jul 2021 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961088;
        bh=9sHeRwrUUh9yPtTPlC8N358xe2XQYAzu9ijcoIe1FJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGt79SQzNd2GNs4veI8EtKwK+zqNb5k8wWRhp0AaYITSahHn9RcP8k5JyC/KO/ox3
         CbjZxD1PKc7jBvC1tUk8MY6/pY+RN7yGw1kb1Uow8sMgl3gUbK2BbMDPx+eRhbsXjf
         4HSymDyL8+MaXUxNGkHF22ETA+tpeQR+W3UN1GWqUfisrtNTdxbWz4W+tNxRTKaBia
         RrPmw2XNCRKIrIy1QPZtRJ+ZohmB+frHCgTFZZeT8QRiJbvOxhFnFPKgDZcyNKxW7f
         rJUQSQgYNNtMSDnM1LOnpE5wcX0DraGAmrScKv7c26DCUN07DVr7QVvAOcmOZ89sYQ
         +3I4n/mnqexXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 5.4 16/28] orangefs: fix orangefs df output.
Date:   Sat, 10 Jul 2021 19:50:55 -0400
Message-Id: <20210710235107.3221840-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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


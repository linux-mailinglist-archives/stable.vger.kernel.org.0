Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7483C392A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhGJX5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234159AbhGJX4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC0F56141A;
        Sat, 10 Jul 2021 23:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961147;
        bh=wgxYcTgE1IyXhY2dHPu39iYdHLNL7gNaAHZJBz0shPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rN6AVozjNxvWtygKth+OPeE63pTt7gg1equchzXfF+mdOtDd4f1+WgdmD4b1tpTpt
         kVY+HMzIExo+CoF1pQNZbFq7YHWVAFlGXKl5wHctKTHmOqiAMJAHSjA1gs9GQ7yGN2
         IGq2LRaOz9VoyT4lIwoI4yuAx22RVn4I3ydkagMTTwVLCUoEAXNqeQDN5Bf4KcImuT
         kAQnu5TGK92IoTaE0g5NiLf1tbAPvw5BFemgdX25s9zHCYp/QIPw2fj9N/Az5mUQ/z
         BEwyOvIu1WTl1Z5zs6X6t6wH6aOvopuAVOQpFCo9vtI07P+CiwOYsruR/t0JpDp2DG
         Tb1QG/lRMbOCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.14 11/21] orangefs: fix orangefs df output.
Date:   Sat, 10 Jul 2021 19:52:02 -0400
Message-Id: <20210710235212.3222375-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
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
index 1997ce49ab46..e5f7df28793d 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -197,7 +197,7 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = (sector_t) new_op->downcall.resp.statfs.blocks_avail;
 	buf->f_files = (sector_t) new_op->downcall.resp.statfs.files_total;
 	buf->f_ffree = (sector_t) new_op->downcall.resp.statfs.files_avail;
-	buf->f_frsize = sb->s_blocksize;
+	buf->f_frsize = 0;
 
 out_op_release:
 	op_release(new_op);
-- 
2.30.2


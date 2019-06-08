Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D7C39E75
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbfFHLtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbfFHLtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:49:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB2F21721;
        Sat,  8 Jun 2019 11:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994541;
        bh=moJsJBMoYx4k8ivgkBq1tYWon+Oh5xmtgch09zQ/F4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFszsnTHDNCKzxCsQyzC76VOKJ2ZjTMPHzee7VeDR22YaJyKmv0SZQ/3Ku51Bqj25
         KnwD1pfniEPpjaQ+4m/yiSA0S3EjIjIZ4Z0cZyy6uLTq9hEzEUU2RbDCNaLQ1La0/a
         se3byWP/PYYPOJOgctKQ/HvM1A5+TRmkN5YOt80g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 08/13] configfs: Fix use-after-free when accessing sd->s_dentry
Date:   Sat,  8 Jun 2019 07:48:40 -0400
Message-Id: <20190608114847.9973-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114847.9973-1-sashal@kernel.org>
References: <20190608114847.9973-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit f6122ed2a4f9c9c1c073ddf6308d1b2ac10e0781 ]

In the vfs_statx() context, during path lookup, the dentry gets
added to sd->s_dentry via configfs_attach_attr(). In the end,
vfs_statx() kills the dentry by calling path_put(), which invokes
configfs_d_iput(). Ideally, this dentry must be removed from
sd->s_dentry but it doesn't if the sd->s_count >= 3. As a result,
sd->s_dentry is holding reference to a stale dentry pointer whose
memory is already freed up. This results in use-after-free issue,
when this stale sd->s_dentry is accessed later in
configfs_readdir() path.

This issue can be easily reproduced, by running the LTP test case -
sh fs_racer_file_list.sh /config
(https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/fs/racer/fs_racer_file_list.sh)

Fixes: 76ae281f6307 ('configfs: fix race between dentry put and lookup')
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index a7a1b218f308..8e709b641b55 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -58,15 +58,13 @@ static void configfs_d_iput(struct dentry * dentry,
 	if (sd) {
 		/* Coordinate with configfs_readdir */
 		spin_lock(&configfs_dirent_lock);
-		/* Coordinate with configfs_attach_attr where will increase
-		 * sd->s_count and update sd->s_dentry to new allocated one.
-		 * Only set sd->dentry to null when this dentry is the only
-		 * sd owner.
-		 * If not do so, configfs_d_iput may run just after
-		 * configfs_attach_attr and set sd->s_dentry to null
-		 * even it's still in use.
+		/*
+		 * Set sd->s_dentry to null only when this dentry is the one
+		 * that is going to be killed.  Otherwise configfs_d_iput may
+		 * run just after configfs_attach_attr and set sd->s_dentry to
+		 * NULL even it's still in use.
 		 */
-		if (atomic_read(&sd->s_count) <= 2)
+		if (sd->s_dentry == dentry)
 			sd->s_dentry = NULL;
 
 		spin_unlock(&configfs_dirent_lock);
-- 
2.20.1


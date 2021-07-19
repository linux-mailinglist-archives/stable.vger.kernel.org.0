Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2FC3CE36F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbhGSPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348315AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 018DC613AF;
        Mon, 19 Jul 2021 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711204;
        bh=UPbSodydsPHpuD3XLoi8HRG9q6RFEhnSTDltOPPVyX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCnlBBM2LB7DJSj4I3pdYuq2Gg+2tliu+40jvselvJHvXuY9CefdGpPLaXj7axNhw
         M+Yw7O6pOhoqgWqqtHZxiJkUfRZ0JJozBM1YgO6MWYPYNffcluvP8toVdwh6FFixqH
         c1PN5jEdygAQGDpuzSGyOwYY2RniRsiHfwjUkzr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 239/351] f2fs: remove false alarm on iget failure during GC
Date:   Mon, 19 Jul 2021 16:53:05 +0200
Message-Id: <20210719144952.847519308@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 132e3209789c647e37dc398ef36af4de13f104b4 ]

This patch removes setting SBI_NEED_FSCK when GC gets an error on f2fs_iget,
since f2fs_iget can give ENOMEM and others by race condition.
If we set this critical fsck flag, we'll get EIO during fsync via the below
code path.

In f2fs_inplace_write_data(),

	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK) || f2fs_cp_error(sbi)) {
		err = -EIO;
		goto drop_bio;
	}

Fixes: 9557727876674 ("f2fs: drop inplace IO if fs status is abnormal")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b40a2da90147..ab63951c08cb 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1450,10 +1450,8 @@ next_step:
 
 		if (phase == 3) {
 			inode = f2fs_iget(sb, dni.ino);
-			if (IS_ERR(inode) || is_bad_inode(inode)) {
-				set_sbi_flag(sbi, SBI_NEED_FSCK);
+			if (IS_ERR(inode) || is_bad_inode(inode))
 				continue;
-			}
 
 			if (!down_write_trylock(
 				&F2FS_I(inode)->i_gc_rwsem[WRITE])) {
-- 
2.30.2




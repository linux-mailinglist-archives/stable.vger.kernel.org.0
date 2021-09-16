Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A340E5CF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351407AbhIPRPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350742AbhIPRMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:12:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B606140B;
        Thu, 16 Sep 2021 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810311;
        bh=nddOb52Hhn8RUwoUAbILSuwemUiC19xRPuibnjId1js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcZOiHLxRbmLqwtWFcHeQ03Y1pbsWEid7OWjmCl95eqdwAwaiM/Py8HdnSwZoVyMm
         AX8bxsJcJ8x3/ZF8qTqZhIe9+PFeD/fcMgbDDDAtdAGKTHIVccS67oqUHNna2eO3II
         R0v+xRhoCThvv2hsfn5inI9WNP4+D+sgXtGUAml8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, stable@kernel.org
Subject: [PATCH 5.14 062/432] f2fs: lets keep writing IOs on SBI_NEED_FSCK
Date:   Thu, 16 Sep 2021 17:56:51 +0200
Message-Id: <20210916155812.887988478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 1ffc8f5f7751f91fe6af527d426a723231b741a6 upstream.

SBI_NEED_FSCK is an indicator that fsck.f2fs needs to be triggered, so it
is not fully critical to stop any IO writes. So, let's allow to write data
instead of reporting EIO forever given SBI_NEED_FSCK, but do keep OPU.

Fixes: 955772787667 ("f2fs: drop inplace IO if fs status is abnormal")
Cc: <stable@kernel.org> # v5.13+
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c    |    2 ++
 fs/f2fs/segment.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2498,6 +2498,8 @@ bool f2fs_should_update_outplace(struct
 		return true;
 	if (f2fs_is_atomic_file(inode))
 		return true;
+	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
+		return true;
 
 	/* swap file is migrating in aligned write mode */
 	if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3563,7 +3563,7 @@ int f2fs_inplace_write_data(struct f2fs_
 		goto drop_bio;
 	}
 
-	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK) || f2fs_cp_error(sbi)) {
+	if (f2fs_cp_error(sbi)) {
 		err = -EIO;
 		goto drop_bio;
 	}



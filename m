Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0307EEFD2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbfKDVxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbfKDVxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:53:20 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06E0A2053B;
        Mon,  4 Nov 2019 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904399;
        bh=g+wi91HW9+cZs9M5/NkuPzE5YUQtA1qquDKeM0/R1KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyJCpkgtACcte+yUHHQSWJkI7giNr5GvNGiDU7ErAYzNUA9LQdNnLFqP4zWO8C4gP
         6q8YjpKkSLw3uHxbjOcfRX14ofx8bRd6xFF0YGR/W7N6jNDDzduhtDCcksL5TM1IBh
         01IZUox1GKuKZzvzA75LIN/ZR982mOsUXN6ojgw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/95] f2fs: flush quota blocks after turnning it off
Date:   Mon,  4 Nov 2019 22:44:04 +0100
Message-Id: <20191104212040.828524358@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0e0667b625cf64243df83171bff61f9d350b9ca5 ]

After quota_off, we'll get some dirty blocks. If put_super don't have a chance
to flush them by checkpoint, it causes NULL pointer exception in end_io after
iput(node_inode). (e.g., by checkpoint=disable)

Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e70975ca723b7..0f3209b23c940 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1523,6 +1523,12 @@ void f2fs_quota_off_umount(struct super_block *sb)
 			set_sbi_flag(F2FS_SB(sb), SBI_NEED_FSCK);
 		}
 	}
+	/*
+	 * In case of checkpoint=disable, we must flush quota blocks.
+	 * This can cause NULL exception for node_inode in end_io, since
+	 * put_super already dropped it.
+	 */
+	sync_filesystem(sb);
 }
 
 int f2fs_get_projid(struct inode *inode, kprojid_t *projid)
-- 
2.20.1




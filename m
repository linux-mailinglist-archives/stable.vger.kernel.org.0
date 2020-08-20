Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE4224BEB8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgHTNbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728272AbgHTJce (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:32:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06FB822BEF;
        Thu, 20 Aug 2020 09:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915954;
        bh=rOZmfox11fUmQvakmoBgObEEml7gBuYfZpBmV3cPfbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fuFN5He1zIBZY4WzSuACAmtTyZjGfLjXGK3nxX4XfH0719iQjm3KnI3Nr20Ol/5Wr
         xbFw2UkudGAYMiZ5ir2TJJhmv0Jkz9gPMQ3cMo8DI6JVEujHD9wCuY7ei6zHQg5PaT
         MStcHyHllepw4lFM4l/mv/D1B1g8NXCiRvIk0nxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 163/232] f2fs: compress: fix to update isize when overwriting compressed file
Date:   Thu, 20 Aug 2020 11:20:14 +0200
Message-Id: <20200820091620.706719697@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 944dd22ea4475bd11180fd2f431a4a547ca4d8f5 ]

We missed to update isize of compressed file in write_end() with
below case:

cluster size is 16KB

- write 14KB data from offset 0
- overwrite 16KB data from offset 0

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 326c63879ddc8..6e9017e6a8197 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3432,6 +3432,10 @@ static int f2fs_write_end(struct file *file,
 	if (f2fs_compressed_file(inode) && fsdata) {
 		f2fs_compress_write_end(inode, fsdata, page->index, copied);
 		f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
+
+		if (pos + copied > i_size_read(inode) &&
+				!f2fs_verity_in_progress(inode))
+			f2fs_i_size_write(inode, pos + copied);
 		return copied;
 	}
 #endif
-- 
2.25.1




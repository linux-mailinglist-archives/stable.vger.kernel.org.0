Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E323B6219
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhF1OmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235516AbhF1OkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A49361C98;
        Mon, 28 Jun 2021 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890793;
        bh=qrm+hkf7wqSwCg6bihorCssQuzlUMsUfTnn4xbM+jv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNFl4mPzNgvEx4Q/SgNnm2gXmC9/8sg+QGwmcN5PTLFg/BT5MINN+/DCmVPDa6H1h
         UQG0KAbPhaWLmJt+NKx30T4px9knC/ahrb9S+YjjKsOEMVTefIZ+XFuBd4a6EtyY2T
         jB4uR16EKfsBNpi/pBzlzC6+HOzKNGZMEBcC8mWrkJ7lJijrMZvy3ALvfmbAUNwinb
         +RfmOSqbdgxSrG+32eogLx7bxcUSBau2AZMxbi2sJzzlLYGcVuFOloGOFhq1IMsXIE
         OOXu16SeITv9NGcV8FlxaEngMaZq7aIYD+ItrUZIDhc+FC57Om1GCEmVIL8lAW6u3n
         MNHcnnQuwOjpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/109] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Mon, 28 Jun 2021 10:31:23 -0400
Message-Id: <20210628143305.32978-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 43a511c44e58e357a687d61a20cf5ef1dc9e5a7c ]

When a direct I/O write falls entirely and falls back to buffered I/O and the
buffered I/O fails, the write failed with return value 0 instead of the error
number reported by the buffered I/O. Fix that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 143e7d518c5d..7c69486d556f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -822,8 +822,11 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		current->backing_dev_info = inode_to_bdi(inode);
 		buffered = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 		current->backing_dev_info = NULL;
-		if (unlikely(buffered <= 0))
+		if (unlikely(buffered <= 0)) {
+			if (!ret)
+				ret = buffered;
 			goto out_unlock;
+		}
 
 		/*
 		 * We need to ensure that the page cache pages are written to
-- 
2.30.2


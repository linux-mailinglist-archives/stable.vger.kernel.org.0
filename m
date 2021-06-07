Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894C739E34D
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhFGQWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhFGQUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:20:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 667C1616E9;
        Mon,  7 Jun 2021 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082497;
        bh=qrm+hkf7wqSwCg6bihorCssQuzlUMsUfTnn4xbM+jv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMdj34SL9sK2A72HMO4A+toV7EthPIigkjcBu/Wg40CNDnSGln9cxmFrhwW7Z+R7d
         7m+zvM4ZeFqm8/c+zOCQIY6i6Q8CaQBmmgtSddHIM4F1EsFf7GR08xIVYfeMRQ8Qj6
         NdiyvRrT/kWV93oDLSKq47TUkMEVqVhrV74giBD3D6KW0HYxkAf4okDqiVTrKRhAaA
         rWy77EYeWHzJoxaamrNyB6NHLbJABZ6Z0Zm80CXiZV97I2Nf1zgBHbWknPNspkdzhc
         8ZKx++QHh7aiLLtxkVFPSnzE4J0Hw4UlS16llPmHSGtoyA2L3R8wcsURgEHKJ5ZFdc
         74sCv7m6NFdIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 07/21] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Mon,  7 Jun 2021 12:14:34 -0400
Message-Id: <20210607161448.3584332-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
MIME-Version: 1.0
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


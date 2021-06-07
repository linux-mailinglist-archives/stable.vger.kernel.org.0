Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1C939E1FC
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhFGQOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhFGQOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C40E611BD;
        Mon,  7 Jun 2021 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082360;
        bh=h3yfU/nAkZxVju9v0orfVy4nCOFi0WzFrnNTYQYPzLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3RUMw0NBStLauubad3yA7Cp8dbEE4bOgU01W6cycJJ8DaupCSwiHyLIdDF68Q5R5
         TWwVWAITnJWaTXZngSowsGDqZg51VdsFhXVpj6g6JAG/17IT3Plov1LboZZdUlqaC4
         +6UXJrwiQJApsf2uPdM9CeeDsByuXRpo4mn9sev5M8pzBb/oY7AR3jp/iEYxVnBFYR
         WV/CUsWlqoTpRYTR6EDhP3y0zUt1yIloOonaez/bQsNnXuXJ0be46MH62kkcQc3gGH
         kEbTPp15rc9hTQmowbHz2GUNPYkJMaaRQiWTmdjSjRoFfCdWlMuhvyapIJACoXArND
         M3Qc9uiWtP50Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 20/49] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Mon,  7 Jun 2021 12:11:46 -0400
Message-Id: <20210607161215.3583176-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
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
index 2d500f90cdac..a86e6810237a 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -935,8 +935,11 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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


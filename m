Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D1939E2FD
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhFGQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhFGQS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C8561582;
        Mon,  7 Jun 2021 16:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082464;
        bh=aJBITtdeqrdbfjeiTs1BPtY1Q2AAO01Q1a74OYTnp6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpuphMwjPJq+TURvifWgu9iF8JeCsHngu80+r7+4WNsmTn7P9tG/Id/kUxhhCz8ET
         PRM2V+BOzLbWoLAoq+jQIr05zeUQPkQ5tN7Sqt9VSjM/XlCqfAoAU68wz2F69DYuwO
         HhtbzvoYkEON4CeK1bXf0RwJzR6az7qGHEoLuzEKjKUNiCMgtTM4Kvb05MFToT85MQ
         3QmGSX5bWWKnjKg0ITaFF0VCl73Ne7aXN2r8/pJIUfUaidOFHvmbg4UkAHuHwkg7IC
         xlA+SbO+NRMLAu7ltCNs1UyhUUJP+oNVEyp+75az7a549j0w+nODkqSbJcjZOJtso/
         FIYJcfDUtZB5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 11/29] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Mon,  7 Jun 2021 12:13:52 -0400
Message-Id: <20210607161410.3584036-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
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
index 4a10b4e7092a..69c52edf5713 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -875,8 +875,11 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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


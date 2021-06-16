Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B023B3A9FE4
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhFPPmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235290AbhFPPkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3D7613C1;
        Wed, 16 Jun 2021 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857824;
        bh=h3yfU/nAkZxVju9v0orfVy4nCOFi0WzFrnNTYQYPzLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2IF4l58aLpv1lX0JtDWq7oN/T+/25w1dJN0KxKUNZprVEo6nIQiOqoW7hS6frnv7
         z4LnoedanEw46pqUx6MckpiL3vxg0DRXhthBuR3K+bAp3aMgjEDCTtqIkihtRAxAl0
         zPw39N2LBbS7jAm9Egv+ScPaeUODXKqaDwufyV/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 20/48] gfs2: Prevent direct-I/O write fallback errors from getting lost
Date:   Wed, 16 Jun 2021 17:33:30 +0200
Message-Id: <20210616152837.292198696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




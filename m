Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC754206665
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393984AbgFWVlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:41:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387548AbgFWUGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8043720E65;
        Tue, 23 Jun 2020 20:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942773;
        bh=Sc3xsrDQ7Hm+hoonV8rReQsxTqyTTdnoEeJMQvSQLhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5eYZ7E5TBKQg6jeeXrzy573qXKUCCAm7Z9LJNtYmlTTvn6yjVBQYi4KRVUW42YzY
         zZ6A5W7yJqNE/AYqItiGjv/6Fox8d9px87SR7aJiyIeKb+GDVTlZvhdU3jn3WPpzXK
         dlHAPx7EqVqeMQy3wcHFqhlbtm+ZzOj8MAqwmPiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 129/477] fuse: BUG_ON correction in fuse_dev_splice_write()
Date:   Tue, 23 Jun 2020 21:52:06 +0200
Message-Id: <20200623195413.705890948@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 0e9fb6f17ad5b386b75451328975a07d7d953c6d ]

commit 963545357202 ("fuse: reduce allocation size for splice_write")
changed size of bufs array, so BUG_ON which checks the index of the array
shold also be fixed.

[SzM: turn BUG_ON into WARN_ON]

Fixes: 963545357202 ("fuse: reduce allocation size for splice_write")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 97eec7522bf20..5c155437a455d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1977,8 +1977,9 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 		struct pipe_buffer *ibuf;
 		struct pipe_buffer *obuf;
 
-		BUG_ON(nbuf >= pipe->ring_size);
-		BUG_ON(tail == head);
+		if (WARN_ON(nbuf >= count || tail == head))
+			goto out_free;
+
 		ibuf = &pipe->bufs[tail & mask];
 		obuf = &bufs[nbuf];
 
-- 
2.25.1




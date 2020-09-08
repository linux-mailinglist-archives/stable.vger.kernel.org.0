Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D034C261C86
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgIHTVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731107AbgIHQBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B3C123F2A;
        Tue,  8 Sep 2020 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579482;
        bh=HdHRm4k1Unbl63MLg8T1pZK1Y+sHxgKhhFb6EWvWNXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcUDEq1nLBjxNgqS/7x8c9Eu+/f9dhtVFo5xbsz7/TH+AgnJPAjEJr32lze9yLrid
         CK9ThfhIDkirqrI8lONXritzwvNt8Wc4wmpydc7HH0DZkeBZy2SYNG7y+I0rUKkUxp
         4Le8zOxaZl0cRxOzNmwiiC9SLVFkgTtwGYc0lowc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 096/186] fix regression in "epoll: Keep a reference on files added to the check list"
Date:   Tue,  8 Sep 2020 17:23:58 +0200
Message-Id: <20200908152246.285858895@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 77f4689de17c0887775bb77896f4cc11a39bf848 ]

epoll_loop_check_proc() can run into a file already committed to destruction;
we can't grab a reference on those and don't need to add them to the set for
reverse path check anyway.

Tested-by: Marc Zyngier <maz@kernel.org>
Fixes: a9ed4a6560b8 ("epoll: Keep a reference on files added to the check list")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e0decff22ae27..8107e06d7f6f5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1995,9 +1995,9 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			 * during ep_insert().
 			 */
 			if (list_empty(&epi->ffd.file->f_tfile_llink)) {
-				get_file(epi->ffd.file);
-				list_add(&epi->ffd.file->f_tfile_llink,
-					 &tfile_check_list);
+				if (get_file_rcu(epi->ffd.file))
+					list_add(&epi->ffd.file->f_tfile_llink,
+						 &tfile_check_list);
 			}
 		}
 	}
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605326169C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgIHROo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731783AbgIHQTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD6224821;
        Tue,  8 Sep 2020 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579850;
        bh=+YxscV7J2lVBCyljBfqpk5s13WM6bZGZ7/s/1RxM2po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+7GCxLZQJNPJP+JkDh69GWOWtTA+xS73cISG9xmtg9CXXtJ5e1s9lRk5LXmw37G0
         uf+glAylv7F216Okg7VSsClmcbKYCizu3GO+XbWZ0gDfHJnUJBEJlbi57kpgVKxVjN
         VGCoT3LDNbGDO2yvrWMHN02kFcMxL4tCCf6NZYQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/129] fix regression in "epoll: Keep a reference on files added to the check list"
Date:   Tue,  8 Sep 2020 17:25:00 +0200
Message-Id: <20200908152232.650771273@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
index 0d9b1e2b9da72..ae1d32344f7ac 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1992,9 +1992,9 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
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




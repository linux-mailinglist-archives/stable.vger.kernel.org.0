Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5A72666F2
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgIKRfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgIKMye (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:54:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D98F2220A;
        Fri, 11 Sep 2020 12:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828813;
        bh=q5AMvphCxcmQP1H/0lgF/CoRmF8mzY/oFlElmY/dmv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPEC023Vr/vTYUnsRLN4twMUZ9/iZVFxYufDbuhVXPYlx7qW4UH6nK9wUiqxa5axE
         OJHjbAXR5DyAkk2fXQzxUe+4EtDJp3Zc0m4xfwtp3njUnpzFqSL5YFneN5omErZZ3A
         g2h22WU/bTLON6vFPbhJuEq4+7g+0QgkXeUtHXbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/62] fix regression in "epoll: Keep a reference on files added to the check list"
Date:   Fri, 11 Sep 2020 14:46:00 +0200
Message-Id: <20200911122503.245259147@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
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
index b8959d0d4c723..e5324642023d6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1720,9 +1720,9 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
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




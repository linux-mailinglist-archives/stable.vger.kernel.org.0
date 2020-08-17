Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF23246A6F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbgHQPgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730472AbgHQPfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E2A22BEF;
        Mon, 17 Aug 2020 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678554;
        bh=q61iwKxty6pQwSJKWSlbwBdJz6N4UwWGth0ffNuPeBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWyRBvXrX8lt/JhrNzL1vCf5gnw1QUZ/BQgIOskfzQv18hMzmSOW7ombx8ZdyPxHT
         c2Oa0il/+NPrQB+Nn0VS0w2tITfu5vw8ssN6BwuB6pP5VgoS9rzkKvBUcMhUui6uLr
         IgxQnQ3Z9IA55/AoFz9SE+a/vf8FEOufc5hognZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 374/464] dlm: Fix kobject memleak
Date:   Mon, 17 Aug 2020 17:15:27 +0200
Message-Id: <20200817143851.687829580@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 0ffddafc3a3970ef7013696e7f36b3d378bc4c16 ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking
the kobject.

Set do_unreg = 1 before kobject_init_and_add() to ensure that
kobject_put() can be called in its error patch.

Fixes: 901195ed7f4b ("Kobject: change GFS2 to use kobject_init_and_add")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index e93670ecfae5b..624617c12250a 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -622,6 +622,9 @@ static int new_lockspace(const char *name, const char *cluster,
 	wait_event(ls->ls_recover_lock_wait,
 		   test_bit(LSFL_RECOVER_LOCK, &ls->ls_flags));
 
+	/* let kobject handle freeing of ls if there's an error */
+	do_unreg = 1;
+
 	ls->ls_kobj.kset = dlm_kset;
 	error = kobject_init_and_add(&ls->ls_kobj, &dlm_ktype, NULL,
 				     "%s", ls->ls_name);
@@ -629,9 +632,6 @@ static int new_lockspace(const char *name, const char *cluster,
 		goto out_recoverd;
 	kobject_uevent(&ls->ls_kobj, KOBJ_ADD);
 
-	/* let kobject handle freeing of ls if there's an error */
-	do_unreg = 1;
-
 	/* This uevent triggers dlm_controld in userspace to add us to the
 	   group of nodes that are members of this lockspace (managed by the
 	   cluster infrastructure.)  Once it's done that, it tells us who the
-- 
2.25.1




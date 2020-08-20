Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740D824B4CF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgHTKMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731048AbgHTKMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:12:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B886920738;
        Thu, 20 Aug 2020 10:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918339;
        bh=sysaVeh2EdH/GQLRY7NDAYHNoH+duUNyIpglnn51t0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnnFvLHccyfUVa3I1oAGb25aZDU0MmbYH3cG50W+vRbXvQWSxg+LmFaQqMYjQeNIv
         OX3gJJjxwraZFtvbADPfm0KWsscYS46bdF6wV3i9a9b3dZC+Gusc8Jcpkd4ZoBR+iC
         qPoPAHj84m0zeBlg5b9Gs1yhTN4f9pcD2kE5Dqdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/228] dlm: Fix kobject memleak
Date:   Thu, 20 Aug 2020 11:21:50 +0200
Message-Id: <20200820091614.334426704@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
index 9c8c9a09b4a6d..7a6b0327ceb0b 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -633,6 +633,9 @@ static int new_lockspace(const char *name, const char *cluster,
 	wait_event(ls->ls_recover_lock_wait,
 		   test_bit(LSFL_RECOVER_LOCK, &ls->ls_flags));
 
+	/* let kobject handle freeing of ls if there's an error */
+	do_unreg = 1;
+
 	ls->ls_kobj.kset = dlm_kset;
 	error = kobject_init_and_add(&ls->ls_kobj, &dlm_ktype, NULL,
 				     "%s", ls->ls_name);
@@ -640,9 +643,6 @@ static int new_lockspace(const char *name, const char *cluster,
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




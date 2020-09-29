Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E27A27C9C2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgI2MNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2AB523F2C;
        Tue, 29 Sep 2020 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379287;
        bh=vnqIYfPTu+rvfEetg3xuLYLSvU11yjq8XixlVaD1i4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYlrgzOwvht5m03+FTJ0gTa0KsY2lj8b1/8+RJMcyfhVPdivrSAGFDCIKH36XTNHz
         lfWwhKlgbC9UstoTNPhpjJ0ZRELYS1nQBiYvaIpCUexeZs8ou+rhZ4BMdiuh0qJ8Xe
         eow//1eASfM5i437Zkx4g9inP1Al8w+c7MqUyEpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/388] nfsd: Fix a soft lockup race in nfsd_file_mark_find_or_create()
Date:   Tue, 29 Sep 2020 12:57:07 +0200
Message-Id: <20200929110015.122682841@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 90d2f1da832fd23290ef0c0d964d97501e5e8553 ]

If nfsd_file_mark_find_or_create() keeps winning the race for the
nfsd_file_fsnotify_group->mark_mutex against nfsd_file_mark_put()
then it can soft lock up, since fsnotify_add_inode_mark() ends
up always finding an existing entry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 3007b8945d388..51c08ae79063c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -133,9 +133,13 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 						 struct nfsd_file_mark,
 						 nfm_mark));
 			mutex_unlock(&nfsd_file_fsnotify_group->mark_mutex);
-			fsnotify_put_mark(mark);
-			if (likely(nfm))
+			if (nfm) {
+				fsnotify_put_mark(mark);
 				break;
+			}
+			/* Avoid soft lockup race with nfsd_file_mark_put() */
+			fsnotify_destroy_mark(mark, nfsd_file_fsnotify_group);
+			fsnotify_put_mark(mark);
 		} else
 			mutex_unlock(&nfsd_file_fsnotify_group->mark_mutex);
 
-- 
2.25.1




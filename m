Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8372C1D847B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732689AbgERSDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732685AbgERSDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA0BE20715;
        Mon, 18 May 2020 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825023;
        bh=UGI9ls1iXRh4lmBl2zbAQTK+9l9Pllhav6NmdI97tjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJO8axukWI4FWqxDbT4r792UKvJBrRpNvERP7yhfNDvL4qqFWV1kg80wZC7vrwsm2
         TVDxVAvS7BuUpd+SF0s4CUg1Fb014pP3SS4suM+fUmXGo9jYOJnPpFpDnoKPwtHHHg
         t/AxF3xMYRhjeDD2GtUxOjqcG90i2f8rVAX++rUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 098/194] NFS: Fix fscache super_cookie allocation
Date:   Mon, 18 May 2020 19:36:28 +0200
Message-Id: <20200518173540.177761246@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit 15751612734ca0c419ac43ce986c9badcb5e2829 ]

Commit f2aedb713c28 ("NFS: Add fs_context support.") reworked
NFS mount code paths for fs_context support which included
super_block initialization.  In the process there was an extra
return left in the code and so we never call
nfs_fscache_get_super_cookie even if 'fsc' is given on as mount
option.  In addition, there is an extra check inside
nfs_fscache_get_super_cookie for the NFS_OPTION_FSCACHE which
is unnecessary since the only caller nfs_get_cache_cookie
checks this flag.

Fixes: f2aedb713c28 ("NFS: Add fs_context support.")
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache.c | 2 --
 fs/nfs/super.c   | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 8eff1fd806b1c..f517184156068 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -118,8 +118,6 @@ void nfs_fscache_get_super_cookie(struct super_block *sb, const char *uniq, int
 
 	nfss->fscache_key = NULL;
 	nfss->fscache = NULL;
-	if (!(nfss->options & NFS_OPTION_FSCACHE))
-		return;
 	if (!uniq) {
 		uniq = "";
 		ulen = 1;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index dada09b391c65..c0d5240b8a0ac 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1154,7 +1154,6 @@ static void nfs_get_cache_cookie(struct super_block *sb,
 			uniq = ctx->fscache_uniq;
 			ulen = strlen(ctx->fscache_uniq);
 		}
-		return;
 	}
 
 	nfs_fscache_get_super_cookie(sb, uniq, ulen);
-- 
2.20.1




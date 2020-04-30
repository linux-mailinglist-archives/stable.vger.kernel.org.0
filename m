Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D133B1BFB43
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgD3N6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgD3Nyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1390D20870;
        Thu, 30 Apr 2020 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254876;
        bh=2y5orJ/2p1rH66TWBTgBpCZq6mWOcZBuWtjq0rNcpA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBqibr8BMQg7XZ0KbqHjquzxCgSGtvfVCucsAMPmywRHkZvD3tgpRmUYjU0Jp9HCg
         9PwpZBOsf4gOaq9xRS4/YOuzKeJ0OL6y1p8NWRdUiwyAC65v+hWB2s6EiFLPVEwFZQ
         oxY7ZGAb5obHHiVs8OendMJ5r4p/UrbiaepujrUA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/17] nfsd: memory corruption in nfsd4_lock()
Date:   Thu, 30 Apr 2020 09:54:18 -0400
Message-Id: <20200430135433.21204-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135433.21204-1-sashal@kernel.org>
References: <20200430135433.21204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit e1e8399eee72e9d5246d4d1bcacd793debe34dd3 ]

New struct nfsd4_blocked_lock allocated in find_or_allocate_block()
does not initialized nbl_list and nbl_lru.
If conflock allocation fails rollback can call list_del_init()
access uninitialized fields and corrupt memory.

v2: just initialize nbl_list and nbl_lru right after nbl allocation.

Fixes: 76d348fadff5 ("nfsd: have nfsd4_lock use blocking locks for v4.1+ lock")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4509c76716e36..5c9231d5e14a0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -246,6 +246,8 @@ find_or_allocate_block(struct nfs4_lockowner *lo, struct knfsd_fh *fh,
 	if (!nbl) {
 		nbl= kmalloc(sizeof(*nbl), GFP_KERNEL);
 		if (nbl) {
+			INIT_LIST_HEAD(&nbl->nbl_list);
+			INIT_LIST_HEAD(&nbl->nbl_lru);
 			fh_copy_shallow(&nbl->nbl_fh, fh);
 			locks_init_lock(&nbl->nbl_lock);
 			nfsd4_init_cb(&nbl->nbl_cb, lo->lo_owner.so_client,
-- 
2.20.1


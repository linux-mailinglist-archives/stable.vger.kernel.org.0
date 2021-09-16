Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BD140E25A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241218AbhIPQhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244431AbhIPQfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22C73613A1;
        Thu, 16 Sep 2021 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809276;
        bh=2q+XIKWDWafQd4e0ZI4eVsfsQHMA/3IsAN2Ms9BzVLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsWttJkyBcUBX6rH2eGnoiJCNcGAyTcJUKoBpAGmn00v5W31HxMKzJQZ9d9UI1gCM
         uOr6UaGSuDwzfytHMi7hLYWSmyXChnc9Z/cFU4PO0fefha+G+0U4/Cv8BYLjeIRrl9
         Sb60mmtaUpAY3e335AVnISaZc14CufxB9rLGV2F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 095/380] NFSv4/pNFS: Always allow update of a zero valued layout barrier
Date:   Thu, 16 Sep 2021 17:57:32 +0200
Message-Id: <20210916155807.268697706@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 45baadaad7bf9183651fb74f4ed1200da48505a5 ]

A zero value for the layout barrier indicates that it has been cleared
(since seqid '0' is an illegal value), so we should always allow it to
be updated.

Fixes: d29b468da4f9 ("pNFS/NFSv4: Improve rejection of out-of-order layouts")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 3ee607aa007b..6cc5ae51fd80 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -335,7 +335,7 @@ static bool pnfs_seqid_is_newer(u32 s1, u32 s2)
 
 static void pnfs_barrier_update(struct pnfs_layout_hdr *lo, u32 newseq)
 {
-	if (pnfs_seqid_is_newer(newseq, lo->plh_barrier))
+	if (pnfs_seqid_is_newer(newseq, lo->plh_barrier) || !lo->plh_barrier)
 		lo->plh_barrier = newseq;
 }
 
-- 
2.30.2




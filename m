Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B89340DF94
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhIPQLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234735AbhIPQJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EC2361251;
        Thu, 16 Sep 2021 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808485;
        bh=EVDUO2oUt5rJvRUrkuVen1JdDbTj1AOdqi0F3CLini0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ufpSpMlEJtqThVd0yBQpxoDBGpt1wUiQDnSHK2Eer9UhFFrB9XxHyfxLb6UCFZQt
         rCU/iYEDhOcgpxWaQlv/BMsh9pGVgZaw2Q6OcMRnIjgvN3re355zddFUTKnaKUY4vd
         XDFHqD9QEk6ns+kmji/vJsmbOQlH/xW8KNLtDpAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/306] NFSv4/pNFS: Always allow update of a zero valued layout barrier
Date:   Thu, 16 Sep 2021 17:57:01 +0200
Message-Id: <20210916155756.646922134@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index fef0537d15b0..741b6283ac9c 100644
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




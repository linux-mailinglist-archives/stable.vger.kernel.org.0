Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92D40E5DD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343561AbhIPRQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350548AbhIPRN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5392961B55;
        Thu, 16 Sep 2021 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810338;
        bh=Y4UIgB3891sM8ME1fxlQT60gDFlCPHdkCSYW5MO6J/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybmPcfzL0q03Fx2Vcf9MRsu4DxW69urP+fdRsUSPBRw5XiVVy4viOty3zCmZHW+gA
         RhAmD4OnLgShgAV5eoROw35qvJK8T74LBeAPKN1HeH2cjnspB3NXkxun6MG7XM9nzk
         jriWi2dQXkYnBZmvJVzvY+7Nq3pm3wy+6+Vg7Rx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 105/432] NFSv4/pNFS: Always allow update of a zero valued layout barrier
Date:   Thu, 16 Sep 2021 17:57:34 +0200
Message-Id: <20210916155814.329967605@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index da5cacad6979..615ac993b9f9 100644
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




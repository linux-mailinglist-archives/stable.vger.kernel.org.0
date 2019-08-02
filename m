Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F337F247
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390581AbfHBJq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405629AbfHBJq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C110020B7C;
        Fri,  2 Aug 2019 09:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739217;
        bh=iLh6aU/cOBOu4Ut2p12q2FvtYsMgUM1bAlJESk5MVO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0ZAFfx/50llYBrqBW4BMfemw1mJqevUfg8Eenpn7kP0U591QCLQBn30k4xoI92Gv
         mXCQd4Rw9egtSUwqqnitCyU1BmopBG1tVwZI+Kl59JdQrpGq2dDlWA/aohjoI/H113
         X6d1u339Xcm64B6zfSiTcP86al25jbiZG0BDBuP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Tracy <ctracy@engr.scu.edu>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 157/223] nfsd: fix performance-limiting session calculation
Date:   Fri,  2 Aug 2019 11:36:22 +0200
Message-Id: <20190802092248.475502279@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c54f24e338ed2a35218f117a4a1afb5f9e2b4e64 ]

We're unintentionally limiting the number of slots per nfsv4.1 session
to 10.  Often more than 10 simultaneous RPCs are needed for the best
performance.

This calculation was meant to prevent any one client from using up more
than a third of the limit we set for total memory use across all clients
and sessions.  Instead, it's limiting the client to a third of the
maximum for a single session.

Fix this.

Reported-by: Chris Tracy <ctracy@engr.scu.edu>
Cc: stable@vger.kernel.org
Fixes: de766e570413 "nfsd: give out fewer session slots as limit approaches"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 0aacd1c850c3..c4762d8aa9f8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1502,16 +1502,16 @@ static u32 nfsd4_get_drc_mem(struct nfsd4_channel_attrs *ca)
 {
 	u32 slotsize = slot_bytes(ca);
 	u32 num = ca->maxreqs;
-	int avail;
+	unsigned long avail, total_avail;
 
 	spin_lock(&nfsd_drc_lock);
-	avail = min((unsigned long)NFSD_MAX_MEM_PER_SESSION,
-		    nfsd_drc_max_mem - nfsd_drc_mem_used);
+	total_avail = nfsd_drc_max_mem - nfsd_drc_mem_used;
+	avail = min((unsigned long)NFSD_MAX_MEM_PER_SESSION, total_avail);
 	/*
 	 * Never use more than a third of the remaining memory,
 	 * unless it's the only way to give this client a slot:
 	 */
-	avail = clamp_t(int, avail, slotsize, avail/3);
+	avail = clamp_t(int, avail, slotsize, total_avail/3);
 	num = min_t(int, num, avail / slotsize);
 	nfsd_drc_mem_used += num * slotsize;
 	spin_unlock(&nfsd_drc_lock);
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDC40E25D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbhIPQhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240887AbhIPQfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD6F461401;
        Thu, 16 Sep 2021 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809279;
        bh=i7wc2uRKQVQ6nQLuaNp9hIehMq1xIm5c5aaokRAIFrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7Wo5us/KWP7+bROay4B9098NxVgUq3NX0HK7rUzByY9oZT0g99Fax5EAM041mBg7
         ouBt86nl9/NqTu09kTwy2wcHqP+6XxxiOIRmbIyjGjQa3x+rIvunXX9lNPbm1aPQSo
         ranlXBwkySH/5HN4iwVrUV1Yt0iONRxk9qr0sL4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 096/380] NFSv4/pnfs: The layout barrier indicate a minimal value for the seqid
Date:   Thu, 16 Sep 2021 17:57:33 +0200
Message-Id: <20210916155807.301331981@linuxfoundation.org>
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

[ Upstream commit d6236a98b3bab07c0a1455fd1ab46f79c3978cdc ]

The intention of the layout barrier is to ensure that we do not update
the layout to match an older value than the current expectation. Fix the
test in pnfs_layout_stateid_blocked() to reflect that it is legal for
the seqid of the stateid to match that of the barrier.

Fixes: aa95edf309ef ("NFSv4/pnfs: Fix the layout barrier update")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 6cc5ae51fd80..28350d62b9bd 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1004,7 +1004,7 @@ pnfs_layout_stateid_blocked(const struct pnfs_layout_hdr *lo,
 {
 	u32 seqid = be32_to_cpu(stateid->seqid);
 
-	return !pnfs_seqid_is_newer(seqid, lo->plh_barrier) && lo->plh_barrier;
+	return lo->plh_barrier && pnfs_seqid_is_newer(lo->plh_barrier, seqid);
 }
 
 /* lget is set to 1 if called from inside send_layoutget call chain */
-- 
2.30.2




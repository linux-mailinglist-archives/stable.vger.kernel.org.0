Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32F41B3E26
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgDVKZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgDVKZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:25:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51F42071E;
        Wed, 22 Apr 2020 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551143;
        bh=n6t39+OF979Bs8Q5ayswd3zTMygAGJGMY26nzG3Isnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBuYOZoj6VkPlHsZxZUDZ+Ebyb3xVIfkPSwC8rPCrkJm9CNZdMnY8J0fz0RWbYLSx
         Z0j5h7tvc7GQ0KVIl1Yk9Cw3Je97o5NOP1RFnVfvIrBycGPx5C8NeVarXaJ/16gi9a
         FCP7c2jD92QkzjDF8+UUrNyZHPY/skYmWbUxvpNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 075/166] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Date:   Wed, 22 Apr 2020 11:56:42 +0200
Message-Id: <20200422095056.910644276@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 77ca1eed5a7d2bf0905562eb1a15aac76bc19fe4 ]

When I lifted the code in xfs_alloc_ag_vextent_lastblock out of a loop,
I forgot to convert all the accesses to len to be pointer dereferences.

Coverity-id: 1457918
Fixes: 5113f8ec3753ed ("xfs: clean up weird while loop in xfs_alloc_ag_vextent_near")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8053bc96c4d2..5a130409f173e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1515,7 +1515,7 @@ xfs_alloc_ag_vextent_lastblock(
 	 * maxlen, go to the start of this block, and skip all those smaller
 	 * than minlen.
 	 */
-	if (len || args->alignment > 1) {
+	if (*len || args->alignment > 1) {
 		acur->cnt->bc_ptrs[0] = 1;
 		do {
 			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4C1AA3D1
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506143AbgDONMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897054AbgDOLf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0A6C2137B;
        Wed, 15 Apr 2020 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950529;
        bh=S3+DFTY9ckUnubA0TaxtyK1+73sP5tB42POVtudqCGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViqxNMSGs98Kv4wdG5FquDUQYk/nbdUhiTYJ3oxngsTqcNWBrouJaXfRHwpyjXJVE
         Fr8wYjMf0VPV20y0vPpRjkbkKzW0OI9qGQ+4K+aQHrrAkI9tEZvEu8dhXmp//9G1/V
         1TbT5jCj82RvjRXPmaHEqI25zVo7i/5fmGfQiFj0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 038/129] xfs: fix incorrect test in xfs_alloc_ag_vextent_lastblock
Date:   Wed, 15 Apr 2020 07:33:13 -0400
Message-Id: <20200415113445.11881-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

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


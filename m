Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D6029B497
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790224AbgJ0PEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790218AbgJ0PEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:04:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A73DF21D24;
        Tue, 27 Oct 2020 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811041;
        bh=rWw9RkoFgO3Ri4zBEHYMMKs2RmKVtMv8GA4rU0uTgK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bkrdra7wr8J2SlOiLvknl0Br2MYp4Z3X0J8OUpaa8whOQD31rkOqIZrfTWtQyIjff
         kHga7z4RM/hikIqvpE8Ko1Pfi4F366mBgFNYqNocBHSx8aBtKDcnE9i7B6HySmtNHY
         ugL6AKQS6xpu/VML05LjAEKNICt9axvVqSh3Tmgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 345/633] xfs: limit entries returned when counting fsmap records
Date:   Tue, 27 Oct 2020 14:51:28 +0100
Message-Id: <20201027135538.870995535@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit acd1ac3aa22fd58803a12d26b1ab7f70232f8d8d ]

If userspace asked fsmap to count the number of entries, we cannot
return more than UINT_MAX entries because fmh_entries is u32.
Therefore, stop counting if we hit this limit or else we will waste time
to return truncated results.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 4eebcec4aae6c..aa36e7daf82c4 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -256,6 +256,9 @@ xfs_getfsmap_helper(
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
+		if (info->head->fmh_entries == UINT_MAX)
+			return -ECANCELED;
+
 		if (rec_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 
-- 
2.25.1




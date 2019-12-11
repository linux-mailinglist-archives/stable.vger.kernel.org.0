Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E1511B52C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbfLKPUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731844AbfLKPUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 371C1208C3;
        Wed, 11 Dec 2019 15:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077639;
        bh=iZ9RA23LH/EUbUqk2SUqX136lV5m46+PcJdsvvImH+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkrkPx0/5tFluJx0toh3IY2uBqxj66WfJWijKPaEsMewiMwBKS7kor7ZQQ30YVwN5
         EU3tvs3569+TQbZkG+34yEOioOTvbEtAn+ekppQJ16nzHS4DSJEVBOPaEe9PReRFWk
         ZR3HuhNr/sLv+a6hhd2v5sr4N3bOu1faVOWIUH3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/243] iomap: sub-block dio needs to zeroout beyond EOF
Date:   Wed, 11 Dec 2019 16:03:58 +0100
Message-Id: <20191211150344.236508264@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit b450672fb66b4a991a5b55ee24209ac7ae7690ce ]

If we are doing sub-block dio that extends EOF, we need to zero
the unused tail of the block to initialise the data in it it. If we
do not zero the tail of the block, then an immediate mmap read of
the EOF block will expose stale data beyond EOF to userspace. Found
with fsx running sub-block DIO sizes vs MAPREAD/MAPWRITE operations.

Fix this by detecting if the end of the DIO write is beyond EOF
and zeroing the tail if necessary.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 914c07c9e0d6f..d3d227682f7d4 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1700,7 +1700,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		dio->submit.cookie = submit_bio(bio);
 	} while (nr_pages);
 
-	if (need_zeroout) {
+	/*
+	 * We need to zeroout the tail of a sub-block write if the extent type
+	 * requires zeroing or the write extends beyond EOF. If we don't zero
+	 * the block tail in the latter case, we can expose stale data via mmap
+	 * reads of the EOF block.
+	 */
+	if (need_zeroout ||
+	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
 		if (pad)
-- 
2.20.1




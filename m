Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4659311B033
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbfLKPUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732355AbfLKPUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6B72073D;
        Wed, 11 Dec 2019 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077637;
        bh=G5OC/VI4Alby3PvzflFKsf7W2Ngi9FARGAmkruBD+BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pb3u8GK/qcb9rTi49O660UvsAgc3liZRnPA7jXy7PHtfvDNTUoD8sw20OrTg8xTB5
         T0ss2s2HQX9AaBW1uHMEWUgNZRu4tNcLMWSUIBsbdTn/F3n91KUGo5xwY71WZNc2wU
         sSWXBMUeUK7PpoFvtqgRIZbleDiu2sFLWUABHAw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/243] iomap: FUA is wrong for DIO O_DSYNC writes into unwritten extents
Date:   Wed, 11 Dec 2019 16:03:57 +0100
Message-Id: <20191211150344.165936043@linuxfoundation.org>
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

[ Upstream commit 0929d8580071c6a1cec1a7916a8f674c243ceee1 ]

When we write into an unwritten extent via direct IO, we dirty
metadata on IO completion to convert the unwritten extent to
written. However, when we do the FUA optimisation checks, the inode
may be clean and so we issue a FUA write into the unwritten extent.
This means we then bypass the generic_write_sync() call after
unwritten extent conversion has ben done and we don't force the
modified metadata to stable storage.

This violates O_DSYNC semantics. The window of exposure is a single
IO, as the next DIO write will see the inode has dirty metadata and
hence will not use the FUA optimisation. Calling
generic_write_sync() after completion of the second IO will also
sync the first write and it's metadata.

Fix this by avoiding the FUA optimisation when writing to unwritten
extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index fac45206418a2..914c07c9e0d6f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1619,12 +1619,13 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 	if (iomap->flags & IOMAP_F_NEW) {
 		need_zeroout = true;
-	} else {
+	} else if (iomap->type == IOMAP_MAPPED) {
 		/*
-		 * Use a FUA write if we need datasync semantics, this
-		 * is a pure data IO that doesn't require any metadata
-		 * updates and the underlying device supports FUA. This
-		 * allows us to avoid cache flushes on IO completion.
+		 * Use a FUA write if we need datasync semantics, this is a pure
+		 * data IO that doesn't require any metadata updates (including
+		 * after IO completion such as unwritten extent conversion) and
+		 * the underlying device supports FUA. This allows us to avoid
+		 * cache flushes on IO completion.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
 		    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
-- 
2.20.1




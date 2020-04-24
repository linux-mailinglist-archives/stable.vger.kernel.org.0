Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFD11B750A
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDXMak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728012AbgDXMXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF49220706;
        Fri, 24 Apr 2020 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731012;
        bh=nGZDO/K9lYYZW94wZtWdHPaukQfIVFd3XwttEgm9WfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9xsYzkNcJ0fLRBUJjXG0Wl0l7MUMNTJYSEzF44nFRsfxRQyF8khxy9WiQILszutT
         Jlw8HQirE8s7jP9Jvv0ATLfHxqP6/4chNfPi3pP9/C0Nq7xFh5gsVgDTEmDOYQGWym
         ZV4uywZDOxdCKrSr6+GNtHTb0nHLZr8tTGXuKZLc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/26] xfs: fix partially uninitialized structure in xfs_reflink_remap_extent
Date:   Fri, 24 Apr 2020 08:23:04 -0400
Message-Id: <20200424122323.10194-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit c142932c29e533ee892f87b44d8abc5719edceec ]

In the reflink extent remap function, it turns out that uirec (the block
mapping corresponding only to the part of the passed-in mapping that got
unmapped) was not fully initialized.  Specifically, br_state was not
being copied from the passed-in struct to the uirec.  This could lead to
unpredictable results such as the reflinked mapping being marked
unwritten in the destination file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0f08153b49941..6a4fd1738b086 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1053,6 +1053,7 @@ xfs_reflink_remap_extent(
 		uirec.br_startblock = irec->br_startblock + rlen;
 		uirec.br_startoff = irec->br_startoff + rlen;
 		uirec.br_blockcount = unmap_len - rlen;
+		uirec.br_state = irec->br_state;
 		unmap_len = rlen;
 
 		/* If this isn't a real mapping, we're done. */
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197A913335D
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgAGVSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbgAGVFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F31F2081E;
        Tue,  7 Jan 2020 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431114;
        bh=26pRNXp4y9ynyMwAZNrOVO5Yl5vRpAbkefRc+U5H31I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHwKKzVfnlJuVWx8jSspxVZ/hjDmsLVuJFUPqKHFOilaNc+K3T7s8js+XzGb5XXXi
         FySW3Zp/vaNATbUTr7dzPjXxf9nX/6B/TyHG292aMhATDRzymazrvT/oEvQW1IGmOo
         Mwc3cm98VZFOGTPt0jhpgSzTXsW5l6h5Rr1vv8f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c732f8644185de340492@syzkaller.appspotmail.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/115] xfs: fix mount failure crash on invalid iclog memory access
Date:   Tue,  7 Jan 2020 21:54:08 +0100
Message-Id: <20200107205301.648935842@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

[ Upstream commit 798a9cada4694ca8d970259f216cec47e675bfd5 ]

syzbot (via KASAN) reports a use-after-free in the error path of
xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
handle the case of a fully initialized ->l_iclog linked list.
Instead, it assumes that the list is partially constructed and NULL
terminated.

This bug manifested because there was no possible error scenario
after iclog list setup when the original code was added.  Subsequent
code and associated error conditions were added some time later,
while the original error handling code was never updated. Fix up the
error loop to terminate either on a NULL iclog or reaching the end
of the list.

Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c3b610b687d1..7bba551cbf90 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1578,6 +1578,8 @@ xlog_alloc_log(
 		if (iclog->ic_bp)
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
+		if (prev_iclog == log->l_iclog)
+			break;
 	}
 	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
-- 
2.20.1




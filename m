Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769A02E3BF4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406574AbgL1N4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406545AbgL1N4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1C4205CB;
        Mon, 28 Dec 2020 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163757;
        bh=5wHv4GcBZGlIOVSG1HNdblnQfI/OavW97mCPO8ECgAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xzfv9GwEE7u/KvPzRs7ht+pS0dG4oRB1veXuvPFmg2XEHmF6QEEiayN9DNkX+NxwR
         DK9LMD/rpFDU2gKuo4vJ4H+38Rz2nnpqPgXN4kbU/Nnp0ipVKaTM/6di3NTRuVaGfD
         wwspF323yCSiyIlk0qDGN2WAMh/Ge1KdL5T1Um2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 5.4 396/453] jfs: Fix array index bounds check in dbAdjTree
Date:   Mon, 28 Dec 2020 13:50:32 +0100
Message-Id: <20201228124956.259330058@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit c61b3e4839007668360ed8b87d7da96d2e59fc6c upstream.

Bounds checking tools can flag a bug in dbAdjTree() for an array index
out of bounds in dmt_stree. Since dmt_stree can refer to the stree in
both structures dmaptree and dmapctl, use the larger array to eliminate
the false positive.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jfs/jfs_dmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/jfs_dmap.h
+++ b/fs/jfs/jfs_dmap.h
@@ -183,7 +183,7 @@ typedef union dmtree {
 #define	dmt_leafidx	t1.leafidx
 #define	dmt_height	t1.height
 #define	dmt_budmin	t1.budmin
-#define	dmt_stree	t1.stree
+#define	dmt_stree	t2.stree
 
 /*
  *	on-disk aggregate disk allocation map descriptor.



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A641B3D0A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgDVKLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgDVKLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A432075A;
        Wed, 22 Apr 2020 10:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550265;
        bh=N5J9ZYL1hq7IPOPZg5qQPF4MWiEvJy7wIJMDw9IxfVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3JqBX7zJ6PIn2x5uWmLdh4TloleuI/avZAVx5d6qhE5AXqsKvRsnahVy7RDMo17u
         Akg/X/2ND78qe7se5zEeArzRdF7f5psE5PbHQx32Aw/BcG/jU3/sRTWpg/cvU9e07A
         XgfoytA0Khl+sqJq+MO6vQt4ofCQEUwMWLT0lBqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 076/199] NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()
Date:   Wed, 22 Apr 2020 11:56:42 +0200
Message-Id: <20200422095105.739175307@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit add42de31721fa29ed77a7ce388674d69f9d31a4 upstream.

When we detach a subrequest from the list, we must also release the
reference it holds to the parent.

Fixes: 5b2b5187fa85 ("NFS: Fix nfs_page_group_destroy() and nfs_lock_and_join_requests() race cases")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -422,6 +422,7 @@ nfs_destroy_unlinked_subrequests(struct
 		}
 
 		subreq->wb_head = subreq;
+		nfs_release_request(old_head);
 
 		if (test_and_clear_bit(PG_INODE_REF, &subreq->wb_flags)) {
 			nfs_release_request(subreq);



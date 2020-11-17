Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A9F2B6209
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgKQNYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730251AbgKQNYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:24:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880682463D;
        Tue, 17 Nov 2020 13:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619488;
        bh=xhuf5kVcAd+r0hR0MjC1AMRf/nh1BrTah9XZeQ+luLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ki2DqJvZAFn3edKPbekCbGurPo5jMel2qAPgoKt8gWwcYvr8FrXXJzfjajg/etnc/
         oIB8K1XA10aaGXAznxmNsBMY+chYsY/bBsRFpZwkk6p/lXIKGRE6esPs+MioX7CTsQ
         Q3kEtaBNea+uMV+MRo1y7v5e1z3/UxmzzoCrmPws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/151] gfs2: Add missing truncate_inode_pages_final for sd_aspace
Date:   Tue, 17 Nov 2020 14:04:46 +0100
Message-Id: <20201117122124.158873971@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit a9dd945ccef07a904e412f208f8de708a3d7159e ]

Gfs2 creates an address space for its rgrps called sd_aspace, but it never
called truncate_inode_pages_final on it. This confused vfs greatly which
tried to reference the address space after gfs2 had freed the superblock
that contained it.

This patch adds a call to truncate_inode_pages_final for sd_aspace, thus
avoiding the use-after-free.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 5935ce5ae5636..50c925d9c6103 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -689,6 +689,7 @@ restart:
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
 	gfs2_gl_hash_clear(sdp);
+	truncate_inode_pages_final(&sdp->sd_aspace);
 	gfs2_delete_debugfs_file(sdp);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
-- 
2.27.0




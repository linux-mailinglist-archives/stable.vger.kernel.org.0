Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730E142907B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238180AbhJKOJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240156AbhJKOGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 138B861050;
        Mon, 11 Oct 2021 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960827;
        bh=w7x9mFqiFd5Zyfxp9xbNc30nBdw8VSQASUqtHIGY/3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3ocXysu2+W7AbWMIKg8W2rNF8Y3IZjRLqFpbCg0zZxBHRfYs3VWUQg+KWFxeAcUp
         NRDzqQHz+nhP+OmNpRgcXziDR1eBpPC5+IZS8GAsnNBdXNQrhC7jDGIkWOSr2zmrk7
         HhD2A2YSFHQ1TAzCHvyuO7f/RSQSGa4g+nklhOWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/151] afs: Fix afs_launder_page() to set correct start file position
Date:   Mon, 11 Oct 2021 15:45:59 +0200
Message-Id: <20211011134520.651294738@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5c0522484eb54b90f2e46a5db8d7a4ff3ff86e5d ]

Fix afs_launder_page() to set the starting position of the StoreData RPC at
the offset into the page at which the modified data starts instead of at
the beginning of the page (the iov_iter is correctly offset).

The offset got lost during the conversion to passing an iov_iter into
afs_store_data().

Changes:
ver #2:
 - Use page_offset() rather than manually calculating it[1].

Fixes: bd80d8a80e12 ("afs: Use ITER_XARRAY for writing")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/YST/0e92OdSH0zjg@casper.infradead.org/ [1]
Link: https://lore.kernel.org/r/162880783179.3421678.7795105718190440134.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/162937512409.1449272.18441473411207824084.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/162981148752.1901565.3663780601682206026.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/163005741670.2472992.2073548908229887941.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/163221839087.3143591.14278359695763025231.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/163292980654.4004896.7134735179887998551.stgit@warthog.procyon.org.uk/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 2dfe3b3a53d6..f24370f5c774 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -974,8 +974,7 @@ int afs_launder_page(struct page *page)
 		iov_iter_bvec(&iter, WRITE, bv, 1, bv[0].bv_len);
 
 		trace_afs_page_dirty(vnode, tracepoint_string("launder"), page);
-		ret = afs_store_data(vnode, &iter, (loff_t)page->index * PAGE_SIZE,
-				     true);
+		ret = afs_store_data(vnode, &iter, page_offset(page) + f, true);
 	}
 
 	trace_afs_page_dirty(vnode, tracepoint_string("laundered"), page);
-- 
2.33.0




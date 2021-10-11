Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9EE429077
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbhJKOJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239272AbhJKOGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F8E61214;
        Mon, 11 Oct 2021 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960824;
        bh=50oME831S3Wg+JzgZ5JeOp45VWeZ+pM3vP9xiNjtWNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZqTxlRiBGbc5UDUhm/2VYFvoNcPqasJiUDU2TSf9U2WnPp+CEQTZBMBBVsSmpc27
         loCHOegMolWHoibcV1lXhszxQQ9q1gb48al9axrK9YK6HUdM4oT5k2dfD3y1shRuvT
         jhgkqEjuHy3cniWhuqFJMmCTktigYwq7lfSdbLjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, linux-cachefs@redhat.com,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 086/151] netfs: Fix READ/WRITE confusion when calling iov_iter_xarray()
Date:   Mon, 11 Oct 2021 15:45:58 +0200
Message-Id: <20211011134520.620511034@linuxfoundation.org>
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

[ Upstream commit 330de47d14af0c3995db81cc03cf5ca683d94d81 ]

Fix netfs_clear_unread() to pass READ to iov_iter_xarray() instead of WRITE
(the flag is about the operation accessing the buffer, not what sort of
access it is doing to the buffer).

Fixes: 3d3c95046742 ("netfs: Provide readahead and readpage netfs helpers")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
cc: linux-cachefs@redhat.com
cc: linux-afs@lists.infradead.org
cc: ceph-devel@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: linux-nfs@vger.kernel.org
cc: v9fs-developer@lists.sourceforge.net
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
Link: https://lore.kernel.org/r/162729351325.813557.9242842205308443901.stgit@warthog.procyon.org.uk/
Link: https://lore.kernel.org/r/162886603464.3940407.3790841170414793899.stgit@warthog.procyon.org.uk
Link: https://lore.kernel.org/r/163239074602.1243337.14154704004485867017.stgit@warthog.procyon.org.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/read_helper.c b/fs/netfs/read_helper.c
index 0b6cd3b8734c..994ec22d4040 100644
--- a/fs/netfs/read_helper.c
+++ b/fs/netfs/read_helper.c
@@ -150,7 +150,7 @@ static void netfs_clear_unread(struct netfs_read_subrequest *subreq)
 {
 	struct iov_iter iter;
 
-	iov_iter_xarray(&iter, WRITE, &subreq->rreq->mapping->i_pages,
+	iov_iter_xarray(&iter, READ, &subreq->rreq->mapping->i_pages,
 			subreq->start + subreq->transferred,
 			subreq->len   - subreq->transferred);
 	iov_iter_zero(iov_iter_count(&iter), &iter);
-- 
2.33.0




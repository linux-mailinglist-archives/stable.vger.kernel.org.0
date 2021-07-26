Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46DE3D61FA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhGZPdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232402AbhGZPcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B202960F5A;
        Mon, 26 Jul 2021 16:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315941;
        bh=3hvMd/IAYmDN0sjkeWmBdjgWFqGKtAgVsF1jwa1xXhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGkikvAk8z9anGzPN5tsh5bJ9gGbdHYf/j1hEd0RWfeVk/xHoHtIsQjo8IMR/2L3j
         YeU2tM0t6BFSrlmuLRy1Vlx5Js2AudDpiSz3SS71YLEQuxxOMjFSUYkzfHm2rnXKbr
         uO6aDDhOKbjmnYtSGNtGSuUbtij+73oD4ZArPYF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 126/223] afs: check function return
Date:   Mon, 26 Jul 2021 17:38:38 +0200
Message-Id: <20210726153850.383876856@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit afe6949862f77bcc14fa16ad7938a04e84586d6a ]

Static analysis reports this problem

write.c:773:29: warning: Assigned value is garbage or undefined
  mapping->writeback_index = next;
                           ^ ~~~~
The call to afs_writepages_region() can return without setting
next.  So check the function return before using next.

Changes:
 ver #2:
   - Need to fix the range_cyclic case also[1].

Fixes: e87b03f5830e ("afs: Prepare for use of THPs")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20210430155031.3287870-1-trix@redhat.com
Link: https://lore.kernel.org/r/CAB9dFdvHsLsw7CMnB+4cgciWDSqVjuij4mH3TaXnHQB8sz5rHw@mail.gmail.com/ [1]
Link: https://lore.kernel.org/r/162609464716.3133237.10354897554363093252.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/162610727640.3408253.8687445613469681311.stgit@warthog.procyon.org.uk/ # v2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 3104b62c2082..1ed62e0ccfe5 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -771,13 +771,19 @@ int afs_writepages(struct address_space *mapping,
 	if (wbc->range_cyclic) {
 		start = mapping->writeback_index * PAGE_SIZE;
 		ret = afs_writepages_region(mapping, wbc, start, LLONG_MAX, &next);
-		if (start > 0 && wbc->nr_to_write > 0 && ret == 0)
-			ret = afs_writepages_region(mapping, wbc, 0, start,
-						    &next);
-		mapping->writeback_index = next / PAGE_SIZE;
+		if (ret == 0) {
+			mapping->writeback_index = next / PAGE_SIZE;
+			if (start > 0 && wbc->nr_to_write > 0) {
+				ret = afs_writepages_region(mapping, wbc, 0,
+							    start, &next);
+				if (ret == 0)
+					mapping->writeback_index =
+						next / PAGE_SIZE;
+			}
+		}
 	} else if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX) {
 		ret = afs_writepages_region(mapping, wbc, 0, LLONG_MAX, &next);
-		if (wbc->nr_to_write > 0)
+		if (wbc->nr_to_write > 0 && ret == 0)
 			mapping->writeback_index = next;
 	} else {
 		ret = afs_writepages_region(mapping, wbc,
-- 
2.30.2




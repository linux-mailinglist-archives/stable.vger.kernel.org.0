Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAA83D61EC
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhGZPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233385AbhGZPcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7848060F94;
        Mon, 26 Jul 2021 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315944;
        bh=nnUmP59J08VneG2xcy1CxecUzfxtaRtkKbCF6T2759A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8ktACfPb8+RXzf8lThhMuoUpQkTc7Vn9ImFL6Mzcf/YeRid3AnYd467OpM5f8lN8
         5MS5MEnM7STXRNxJggpCGTy1UJ3PHJexWx+Is0gKU2Cd3wBHlB5PTm7A11F5UJWSxy
         t5rZebiPbUrQ0XXKTSdQrLwl4NFrr8Ww9kMVFAVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 127/223] afs: Fix setting of writeback_index
Date:   Mon, 26 Jul 2021 17:38:39 +0200
Message-Id: <20210726153850.413515482@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5a972474cf685bf99ca430979657095bda3a15c8 ]

Fix afs_writepages() to always set mapping->writeback_index to a page index
and not a byte position[1].

Fixes: 31143d5d515e ("AFS: implement basic file write support")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/CAB9dFdvHsLsw7CMnB+4cgciWDSqVjuij4mH3TaXnHQB8sz5rHw@mail.gmail.com/ [1]
Link: https://lore.kernel.org/r/162610728339.3408253.4604750166391496546.stgit@warthog.procyon.org.uk/ # v2 (no v1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 1ed62e0ccfe5..c0534697268e 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -784,7 +784,7 @@ int afs_writepages(struct address_space *mapping,
 	} else if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX) {
 		ret = afs_writepages_region(mapping, wbc, 0, LLONG_MAX, &next);
 		if (wbc->nr_to_write > 0 && ret == 0)
-			mapping->writeback_index = next;
+			mapping->writeback_index = next / PAGE_SIZE;
 	} else {
 		ret = afs_writepages_region(mapping, wbc,
 					    wbc->range_start, wbc->range_end, &next);
-- 
2.30.2




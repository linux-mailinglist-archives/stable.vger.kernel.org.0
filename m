Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C155615CCF
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfEGGHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfEGFdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C5A21019;
        Tue,  7 May 2019 05:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207216;
        bh=Gza0Tf2zcIx0jq1gzVW4i2us7RjbkGM7Bg3NPcSyrGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMrLt8ibwV0at3oqC6MtPYNEafulfvAtTzLOIifo5HvfspcZn7j0ngwDaNf36UsEW
         iX59xvVHUiYIpoK0lvq7esjIYMX+mIALnj+QYUvbLlkgRko9s2rw/LHT6XOJAl+H8X
         EwgPZ+upWVR143zoMJNSWrOg1YX5px6lo9hdoQNg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Jonathan Billings <jsbillin@umich.edu>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 31/99] afs: Unlock pages for __pagevec_release()
Date:   Tue,  7 May 2019 01:31:25 -0400
Message-Id: <20190507053235.29900-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit 21bd68f196ca91fc0f3d9bd1b32f6e530e8c1c88 ]

__pagevec_release() complains loudly if any page in the vector is still
locked.  The pages need to be locked for generic_error_remove_page(), but
that function doesn't actually unlock them.

Unlock the pages afterwards.

Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Jonathan Billings <jsbillin@umich.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 72efcfcf9f95..0122d7445fba 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -264,6 +264,7 @@ static void afs_kill_pages(struct address_space *mapping,
 				first = page->index + 1;
 			lock_page(page);
 			generic_error_remove_page(mapping, page);
+			unlock_page(page);
 		}
 
 		__pagevec_release(&pv);
-- 
2.20.1


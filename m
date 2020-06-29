Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737CA20E809
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgF2WCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6551B247FC;
        Mon, 29 Jun 2020 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444158;
        bh=6LsGxbjBijB3n3BH6v7BJ+ueot9xAGvIAWaP9F5Uejg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9wr6KV+lPmJiuwwUFvvS2VF33j8aR3V7ExpMPEzv/BLOdGD1JAcdIdjhQqkvgOWj
         KC3CbpdBJethLn6FVpw4l9A95XMzTjCnmE3uSSJj/xhIfKG5+nTjgrKOhTTOCL/Ntm
         0a2mkAdjspSSZHn/1CLqqss0C0KXF6h9m2dvW1oA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 264/265] dm writecache: add cond_resched to loop in persistent_memory_claim()
Date:   Mon, 29 Jun 2020 11:18:17 -0400
Message-Id: <20200629151818.2493727-265-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit d35bd764e6899a7bea71958f08d16cea5bfa1919 upstream.

Add cond_resched() to a loop that fills in the mapper memory area
because the loop can be executed many times.

Fixes: 48debafe4f2fe ("dm: add writecache target")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-writecache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 856b3515654ff..5cc94f57421ca 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -286,6 +286,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 			while (daa-- && i < p) {
 				pages[i++] = pfn_t_to_page(pfn);
 				pfn.val++;
+				if (!(i & 15))
+					cond_resched();
 			}
 		} while (i < p);
 		wc->memory_map = vmap(pages, p, VM_MAP, PAGE_KERNEL);
-- 
2.25.1


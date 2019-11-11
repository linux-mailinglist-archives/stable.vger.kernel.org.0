Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DE6F7E4C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfKKSra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbfKKSr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E6621655;
        Mon, 11 Nov 2019 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498045;
        bh=MnjhQlZwaODzj+JadDJkhh9j+AWvo5XL4w5QwgNBMyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKtqDXYO46Zt4xBKjMyIG4pswWAUWDAy+HVrb+6kQHgFbUsRkyj/POZ1LcFv6lpkm
         rQcaqzUodYObG3rGMczr1QHejd35hEdugkABKrEonLFZ0jI08K97Y3aCotUDMeHwbd
         +WjuFFiInU4x/WM+rhLHS2Em/ytZpmAdhrbowHYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 125/125] cgroup,writeback: dont switch wbs immediately on dead wbs if the memcg is dead
Date:   Mon, 11 Nov 2019 19:29:24 +0100
Message-Id: <20191111181456.356001524@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 65de03e251382306a4575b1779c57c87889eee49 upstream.

cgroup writeback tries to refresh the associated wb immediately if the
current wb is dead.  This is to avoid keeping issuing IOs on the stale
wb after memcg - blkcg association has changed (ie. when blkcg got
disabled / enabled higher up in the hierarchy).

Unfortunately, the logic gets triggered spuriously on inodes which are
associated with dead cgroups.  When the logic is triggered on dead
cgroups, the attempt fails only after doing quite a bit of work
allocating and initializing a new wb.

While c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping
has no dirty pages") alleviated the issue significantly as it now only
triggers when the inode has dirty pages.  However, the condition can
still be triggered before the inode is switched to a different cgroup
and the logic simply doesn't make sense.

Skip the immediate switching if the associated memcg is dying.

This is a simplified version of the following two patches:

 * https://lore.kernel.org/linux-mm/20190513183053.GA73423@dennisz-mbp/
 * http://lkml.kernel.org/r/156355839560.2063.5265687291430814589.stgit@buzz

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
Acked-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -582,10 +582,13 @@ void wbc_attach_and_unlock_inode(struct
 	spin_unlock(&inode->i_lock);
 
 	/*
-	 * A dying wb indicates that the memcg-blkcg mapping has changed
-	 * and a new wb is already serving the memcg.  Switch immediately.
+	 * A dying wb indicates that either the blkcg associated with the
+	 * memcg changed or the associated memcg is dying.  In the first
+	 * case, a replacement wb should already be available and we should
+	 * refresh the wb immediately.  In the second case, trying to
+	 * refresh will keep failing.
 	 */
-	if (unlikely(wb_dying(wbc->wb)))
+	if (unlikely(wb_dying(wbc->wb) && !css_is_dying(wbc->wb->memcg_css)))
 		inode_switch_wbs(inode, wbc->wb_id);
 }
 



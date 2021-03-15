Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B3E33B9B6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhCOOGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhCOOBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5186264FC2;
        Mon, 15 Mar 2021 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816870;
        bh=kFpslts5D3G7msqJCF7O+pB3eYkIPel2xG/+DNJmbco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT+qkmUIz//HZaFIGaVrIMMUM4UPEi+4xCUCHpHsYQlpO1SVqEfB7fYQZZ3i7UqCO
         yRsAg84Mjy/E/vn6LiYaREa3PINnWHbz4aTJfwmttUrecj+UboRtBKyZmdbnQuAcJQ
         Ye2uWN+/cxyVjLGNKtWAde5olCu13HdOe8Pg+r1c=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 162/168] nvme: unlink head after removing last namespace
Date:   Mon, 15 Mar 2021 14:56:34 +0100
Message-Id: <20210315135555.687459271@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Keith Busch <kbusch@kernel.org>

commit d567572906d986dedb78b37f111c44eba033f3ef upstream.

The driver had been unlinking the namespace head from the subsystem's
list only after the last reference was released, and outside of the
list's subsys->lock protection.

There is no reason to track an empty head, so unlink the entry from the
subsystem's list when the last namespace using that head is removed and
with the mutex lock protecting the list update. The next namespace to
attach reusing the previous NSID will allocate a new head rather than
find the old head with mismatched identifiers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -455,7 +455,6 @@ static void nvme_free_ns_head(struct kre
 
 	nvme_mpath_remove_disk(head);
 	ida_simple_remove(&head->subsys->ns_ida, head->instance);
-	list_del_init(&head->entry);
 	cleanup_srcu_struct(&head->srcu);
 	nvme_put_subsystem(head->subsys);
 	kfree(head);
@@ -3374,7 +3373,6 @@ static int __nvme_check_ids(struct nvme_
 
 	list_for_each_entry(h, &subsys->nsheads, entry) {
 		if (nvme_ns_ids_valid(&new->ids) &&
-		    !list_empty(&h->list) &&
 		    nvme_ns_ids_equal(&new->ids, &h->ids))
 			return -EINVAL;
 	}
@@ -3629,6 +3627,8 @@ static int nvme_alloc_ns(struct nvme_ctr
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
+	if (list_empty(&ns->head->list))
+		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
 	nvme_put_ns_head(ns->head);
  out_free_id:
@@ -3651,7 +3651,10 @@ static void nvme_ns_remove(struct nvme_n
 
 	mutex_lock(&ns->ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
+	if (list_empty(&ns->head->list))
+		list_del_init(&ns->head->entry);
 	mutex_unlock(&ns->ctrl->subsys->lock);
+
 	synchronize_rcu(); /* guarantee not available in head->list */
 	nvme_mpath_clear_current_path(ns);
 	synchronize_srcu(&ns->head->srcu); /* wait for concurrent submissions */



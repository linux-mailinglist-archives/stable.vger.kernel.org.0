Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566DB431D7B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhJRNv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233357AbhJRNuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1D6561390;
        Mon, 18 Oct 2021 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564257;
        bh=eDTojDbsL2yDNqpN0qA6hR0iQ4xi9fQ2ndFuesSquwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf0MMjLUPkvXTtK7VikIRkzrp+KixO/HS+9cFBciUpttlPxBagpHpkxoUjVcnWQUH
         cczclb8aACO8mW3Mr3VJi6NlcgfPj+YUT0fCkm/KAhZbMcyw+RAvw6ERWodGHYleUp
         kO0udwKyPGRRUv4YuKvuW67mHkvPdZLRN9OLi3nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.14 020/151] dm rq: dont queue request to blk-mq during DM suspend
Date:   Mon, 18 Oct 2021 15:23:19 +0200
Message-Id: <20211018132341.334019450@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit b4459b11e84092658fa195a2587aff3b9637f0e7 upstream.

DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.

But blk-mq's unquiesce may come from outside events, such as elevator
switch, updating nr_requests or others, and request may come during
suspend, so simply ask for blk-mq to requeue it.

Fixes one kernel panic issue when running updating nr_requests and
dm-mpath suspend/resume stress test.

Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-rq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struc
 	struct mapped_device *md = tio->md;
 	struct dm_target *ti = md->immutable_target;
 
+	/*
+	 * blk-mq's unquiesce may come from outside events, such as
+	 * elevator switch, updating nr_requests or others, and request may
+	 * come during suspend, so simply ask for blk-mq to requeue it.
+	 */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
+		return BLK_STS_RESOURCE;
+
 	if (unlikely(!ti)) {
 		int srcu_idx;
 		struct dm_table *map = dm_get_live_table(md, &srcu_idx);



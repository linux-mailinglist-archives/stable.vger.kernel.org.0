Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928BE1B3DAC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgDVKRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:17:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgDVKRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE4C2076B;
        Wed, 22 Apr 2020 10:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550637;
        bh=20LqGUbpu9uV7aO8fe3tVxSx3iJIER0RsqWKu+XbUFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pS6tZUz41HWo875noCi2CSS4ghBkAJ3vOuIFgR2rDu/iivLV4qWqwX7Z6FPIXoEaL
         oUioWvO+Yu4WCHT3kM4d5tL+v3Ut84fJNWbeIX5/4Fa9vB9x6n3AeQ2VU2LmCcyQoO
         XBvTQ+Fnp0GxuISLrzhL8yN+NXZjxBahg7RIBPH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, cki-project@redhat.com,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 031/118] block, bfq: invoke flush_idle_tree after reparent_active_queues in pd_offline
Date:   Wed, 22 Apr 2020 11:56:32 +0200
Message-Id: <20200422095036.940892995@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit 4d38a87fbb77fb9ff2ff4e914162a8ae6453eff5 upstream.

In bfq_pd_offline(), the function bfq_flush_idle_tree() is invoked to
flush the rb tree that contains all idle entities belonging to the pd
(cgroup) being destroyed. In particular, bfq_flush_idle_tree() is
invoked before bfq_reparent_active_queues(). Yet the latter may happen
to add some entities to the idle tree. It happens if, in some of the
calls to bfq_bfqq_move() performed by bfq_reparent_active_queues(),
the queue to move is empty and gets expired.

This commit simply reverses the invocation order between
bfq_flush_idle_tree() and bfq_reparent_active_queues().

Tested-by: cki-project@redhat.com
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bfq-cgroup.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -877,13 +877,6 @@ static void bfq_pd_offline(struct blkg_p
 		st = bfqg->sched_data.service_tree + i;
 
 		/*
-		 * The idle tree may still contain bfq_queues belonging
-		 * to exited task because they never migrated to a different
-		 * cgroup from the one being destroyed now.
-		 */
-		bfq_flush_idle_tree(st);
-
-		/*
 		 * It may happen that some queues are still active
 		 * (busy) upon group destruction (if the corresponding
 		 * processes have been forced to terminate). We move
@@ -896,6 +889,19 @@ static void bfq_pd_offline(struct blkg_p
 		 * scheduler has taken no reference.
 		 */
 		bfq_reparent_active_queues(bfqd, bfqg, st, i);
+
+		/*
+		 * The idle tree may still contain bfq_queues
+		 * belonging to exited task because they never
+		 * migrated to a different cgroup from the one being
+		 * destroyed now. In addition, even
+		 * bfq_reparent_active_queues() may happen to add some
+		 * entities to the idle tree. It happens if, in some
+		 * of the calls to bfq_bfqq_move() performed by
+		 * bfq_reparent_active_queues(), the queue to move is
+		 * empty and gets expired.
+		 */
+		bfq_flush_idle_tree(st);
 	}
 
 	__bfq_deactivate_entity(entity, false);



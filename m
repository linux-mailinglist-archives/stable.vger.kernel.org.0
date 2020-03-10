Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8F017F882
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgCJMsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgCJMsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA7724697;
        Tue, 10 Mar 2020 12:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844513;
        bh=/OMNevqG0gX9m3pbaALuyBtVUnL99qbRW3KpDyLhr60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4csOn1f8T61hrJPeh4hV0I3A1tbsQ0A63/N7v9/NUU+K8k1BIOXkkveQaOB6doI9
         Eh2BcQgpA/31wFU1kpzbLcza7OjMTMNKZ7kpp+8+iWCDXPHNT9LhaIj3kGoePVy4yc
         KymbA03MIul3IRVWtUYalkNMxZQNPhlBwfczxg5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Evich <cevich@redhat.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/168] block, bfq: get extra ref to prevent a queue from being freed during a group move
Date:   Tue, 10 Mar 2020 13:37:28 +0100
Message-Id: <20200310123635.527448147@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit ecedd3d7e19911ab8fe42f17b77c0a30fe7f4db3 ]

In bfq_bfqq_move(), the bfq_queue, say Q, to be moved to a new group
may happen to be deactivated in the scheduling data structures of the
source group (and then activated in the destination group). If Q is
referred only by the data structures in the source group when the
deactivation happens, then Q is freed upon the deactivation.

This commit addresses this issue by getting an extra reference before
the possible deactivation, and releasing this extra reference after Q
has been moved.

Tested-by: Chris Evich <cevich@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 0999d56bc4d19..ead6e42832982 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -634,6 +634,12 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		bfq_bfqq_expire(bfqd, bfqd->in_service_queue,
 				false, BFQQE_PREEMPTED);
 
+	/*
+	 * get extra reference to prevent bfqq from being freed in
+	 * next possible deactivate
+	 */
+	bfqq->ref++;
+
 	if (bfq_bfqq_busy(bfqq))
 		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
 	else if (entity->on_st)
@@ -653,6 +659,8 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
 		bfq_schedule_dispatch(bfqd);
+	/* release extra ref taken above */
+	bfq_put_queue(bfqq);
 }
 
 /**
-- 
2.20.1




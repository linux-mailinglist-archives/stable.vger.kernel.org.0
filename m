Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94AC10B7E2
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfK0Uhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728644AbfK0Uhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:37:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52C6A215A5;
        Wed, 27 Nov 2019 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887072;
        bh=hWh3MJgtSF6MPAlyllax6M1ln9gZGf9IbFTKoRAXIJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CJF0W2nNustdHEnzUf3URtiFtBzbAkrIsdEzm7Cq3RyMDmdKmT1qVwnoTcYB0GNH
         3+xa3z1KL/os5gV+EtMsVJJWi3itfAmL9b/xc1xAjK/fcE3/lGtt7IR27KvwGllKxb
         2DC/Fej77w4knqi3EwCNuxLg3TwD+30o+nKdVBIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 101/132] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Wed, 27 Nov 2019 21:31:32 +0100
Message-Id: <20191127203024.070462973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

commit 2e91c3694181dc500faffec16c5aaa0ac5e15449 upstream.

After QUEUE_FLAG_DYING has been set any code that is waiting in
get_request() should be woken up.  But to get this behaviour
blk_set_queue_dying() must be used instead of only setting
QUEUE_FLAG_DYING.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2939,9 +2939,7 @@ static void __dm_destroy(struct mapped_d
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	spin_lock_irq(q->queue_lock);
-	queue_flag_set(QUEUE_FLAG_DYING, q);
-	spin_unlock_irq(q->queue_lock);
+	blk_set_queue_dying(q);
 
 	if (dm_request_based(md) && md->kworker_task)
 		flush_kthread_worker(&md->kworker);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0B910BEB4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfK0Upu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbfK0Upt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C9B22178F;
        Wed, 27 Nov 2019 20:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887549;
        bh=E7bp0BOM3t1qTKZFsIcbtokzuEIIenJD4UwrpLkgBBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSi5PPV6g/7TT52jlO+XxvYZ9tt5xvNBPpFQFBN3BACLHqkTQp0+q+91RGXdqyrNv
         NZmnQJ5kLElLjQnlxnyAQeuCl5FVVKO62ugPAYncVv8vgP0kOuH2Qjmgk/wVwncBck
         cPBdgLbM1SwOE1AL85Jce4pHidva/s1Gw30WpAHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 113/151] dm: use blk_set_queue_dying() in __dm_destroy()
Date:   Wed, 27 Nov 2019 21:31:36 +0100
Message-Id: <20191127203043.434613352@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
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
@@ -1946,9 +1946,7 @@ static void __dm_destroy(struct mapped_d
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	spin_lock_irq(q->queue_lock);
-	queue_flag_set(QUEUE_FLAG_DYING, q);
-	spin_unlock_irq(q->queue_lock);
+	blk_set_queue_dying(q);
 
 	if (dm_request_based(md) && md->kworker_task)
 		kthread_flush_worker(&md->kworker);



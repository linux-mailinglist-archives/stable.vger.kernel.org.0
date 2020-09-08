Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B3261A0A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbgIHSaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbgIHQJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A24A2467A;
        Tue,  8 Sep 2020 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580215;
        bh=IJZKVzpfO+JETRzfQYxj3sn5TpAGzZ/se7lU1mhHAD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPK5ilGs/cSTZCkwpYAKIHcGVCthEdBNVBrTf9xITys8dZS1r4i/OlzdCfx/lcIsZ
         7aOgRgy+2egxIoDeu8wfQlcmsazNRnqZLuvW5JjuIrhg3lqwupj/i70MhlwxUvnqXD
         ABiQcAqKwXmtizhfkE7nlAs6cdaNhk8FSopMeElE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Christensen <drc@linux.vnet.ibm.com>,
        Baptiste Covolato <baptiste@arista.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/88] tg3: Fix soft lockup when tg3_reset_task() fails.
Date:   Tue,  8 Sep 2020 17:25:48 +0200
Message-Id: <20200908152223.484423675@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 556699341efa98243e08e34401b3f601da91f5a3 ]

If tg3_reset_task() fails, the device state is left in an inconsistent
state with IFF_RUNNING still set but NAPI state not enabled.  A
subsequent operation, such as ifdown or AER error can cause it to
soft lock up when it tries to disable NAPI state.

Fix it by bringing down the device to !IFF_RUNNING state when
tg3_reset_task() fails.  tg3_reset_task() running from workqueue
will now call tg3_close() when the reset fails.  We need to
modify tg3_reset_task_cancel() slightly to avoid tg3_close()
calling cancel_work_sync() to cancel tg3_reset_task().  Otherwise
cancel_work_sync() will wait forever for tg3_reset_task() to
finish.

Reported-by: David Christensen <drc@linux.vnet.ibm.com>
Reported-by: Baptiste Covolato <baptiste@arista.com>
Fixes: db2199737990 ("tg3: Schedule at most one tg3_reset_task run")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index be845df050399..6fcf9646d141b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7219,8 +7219,8 @@ static inline void tg3_reset_task_schedule(struct tg3 *tp)
 
 static inline void tg3_reset_task_cancel(struct tg3 *tp)
 {
-	cancel_work_sync(&tp->reset_task);
-	tg3_flag_clear(tp, RESET_TASK_PENDING);
+	if (test_and_clear_bit(TG3_FLAG_RESET_TASK_PENDING, tp->tg3_flags))
+		cancel_work_sync(&tp->reset_task);
 	tg3_flag_clear(tp, TX_RECOVERY_PENDING);
 }
 
@@ -11213,18 +11213,27 @@ static void tg3_reset_task(struct work_struct *work)
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 0);
 	err = tg3_init_hw(tp, true);
-	if (err)
+	if (err) {
+		tg3_full_unlock(tp);
+		tp->irq_sync = 0;
+		tg3_napi_enable(tp);
+		/* Clear this flag so that tg3_reset_task_cancel() will not
+		 * call cancel_work_sync() and wait forever.
+		 */
+		tg3_flag_clear(tp, RESET_TASK_PENDING);
+		dev_close(tp->dev);
 		goto out;
+	}
 
 	tg3_netif_start(tp);
 
-out:
 	tg3_full_unlock(tp);
 
 	if (!err)
 		tg3_phy_start(tp);
 
 	tg3_flag_clear(tp, RESET_TASK_PENDING);
+out:
 	rtnl_unlock();
 }
 
-- 
2.25.1




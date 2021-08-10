Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537D23E7E6B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhHJRdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231921AbhHJRcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:32:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C268A6108C;
        Tue, 10 Aug 2021 17:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616753;
        bh=MGfQA6lcM9g8o8bScDfSMHw06mk8qD9asDGzQiw1DAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPZn0Ofz+9Tna2TKpg9iW+uZVDU+PYM+tIfCZmf8wazzi1wKAl7OixJCoixNx3vze
         lEaTUEMHPoSIdkfWQvfdwWFTMtkh5iLm916rhj8oZvOuXS2+ahDJFEYBPUH/nftX0q
         cEIlDX5dXZTnPRAKW30CKZ5o40RwyRYVVwg0FqFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH 4.19 31/54] usb: otg-fsm: Fix hrtimer list corruption
Date:   Tue, 10 Aug 2021 19:30:25 +0200
Message-Id: <20210810172945.199593424@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit bf88fef0b6f1488abeca594d377991171c00e52a upstream.

The HNP work can be re-scheduled while it's still in-fly. This results in
re-initialization of the busy work, resetting the hrtimer's list node of
the work and crashing kernel with null dereference within kernel/timer
once work's timer is expired. It's very easy to trigger this problem by
re-plugging USB cable quickly. Initialize HNP work only once to fix this
trouble.

 Unable to handle kernel NULL pointer dereference at virtual address 00000126)
 ...
 PC is at __run_timers.part.0+0x150/0x228
 LR is at __next_timer_interrupt+0x51/0x9c
 ...
 (__run_timers.part.0) from [<c0187a2b>] (run_timer_softirq+0x2f/0x50)
 (run_timer_softirq) from [<c01013ad>] (__do_softirq+0xd5/0x2f0)
 (__do_softirq) from [<c012589b>] (irq_exit+0xab/0xb8)
 (irq_exit) from [<c0170341>] (handle_domain_irq+0x45/0x60)
 (handle_domain_irq) from [<c04c4a43>] (gic_handle_irq+0x6b/0x7c)
 (gic_handle_irq) from [<c0100b65>] (__irq_svc+0x65/0xac)

Cc: stable@vger.kernel.org
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20210717182134.30262-6-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/usb-otg-fsm.c |    6 +++++-
 include/linux/usb/otg-fsm.h      |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/usb-otg-fsm.c
+++ b/drivers/usb/common/usb-otg-fsm.c
@@ -193,7 +193,11 @@ static void otg_start_hnp_polling(struct
 	if (!fsm->host_req_flag)
 		return;
 
-	INIT_DELAYED_WORK(&fsm->hnp_polling_work, otg_hnp_polling_work);
+	if (!fsm->hnp_work_inited) {
+		INIT_DELAYED_WORK(&fsm->hnp_polling_work, otg_hnp_polling_work);
+		fsm->hnp_work_inited = true;
+	}
+
 	schedule_delayed_work(&fsm->hnp_polling_work,
 					msecs_to_jiffies(T_HOST_REQ_POLL));
 }
--- a/include/linux/usb/otg-fsm.h
+++ b/include/linux/usb/otg-fsm.h
@@ -196,6 +196,7 @@ struct otg_fsm {
 	struct mutex lock;
 	u8 *host_req_flag;
 	struct delayed_work hnp_polling_work;
+	bool hnp_work_inited;
 	bool state_changed;
 };
 



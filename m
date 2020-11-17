Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05652B63B5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgKQNkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732906AbgKQNku (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4511220870;
        Tue, 17 Nov 2020 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620448;
        bh=JlknFSHNSPZpdnSiKuUb0LJ84t/720uPFICk/iEjEaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCw2dku4MVo7sJW9/O6OS6A4NGqJB5213oGdHlGQRbb9RFXrYNMq0eUJSccxvkuF6
         S54gK+thIXLpG3b9LWIbmigCzf+UtzFwNQEmiAwLHLhb4SIyGgv3f1WxxY4IcCju75
         8yVKaY0V/WR6Ry8z+XnJcqFtZiOHFSVQ+zIhxrzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Covici <covici@ccs.covici.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.9 193/255] speakup ttyio: Do not schedule() in ttyio_in_nowait
Date:   Tue, 17 Nov 2020 14:05:33 +0100
Message-Id: <20201117122148.323479648@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 3ed1cfb2cee4355ddef49489897bfe474daeeaec upstream.

With the ltlk and spkout drivers, the index read function, i.e.
in_nowait, is getting called from the read_all_doc mechanism, from
the timer softirq:

Call Trace:
 <IRQ>
 dump_stack+0x71/0x98
 dequeue_task_idle+0x1f/0x28
 __schedule+0x167/0x5d6
 ? trace_hardirqs_on+0x2e/0x3a
 ? usleep_range+0x7f/0x7f
 schedule+0x8a/0xae
 schedule_timeout+0xb1/0xea
 ? del_timer_sync+0x31/0x31
 do_wait_for_common+0xba/0x12b
 ? wake_up_q+0x45/0x45
 wait_for_common+0x37/0x50
 ttyio_in+0x2a/0x6b
 spk_ttyio_in_nowait+0xc/0x13
 spk_get_index_count+0x20/0x93
 cursor_done+0x1c6/0x4c6
 ? read_all_doc+0xb1/0xb1
 call_timer_fn+0x89/0x140
 run_timer_softirq+0x164/0x1a5
 ? read_all_doc+0xb1/0xb1
 ? hrtimer_forward+0x7b/0x87
 ? timerqueue_add+0x62/0x68
 ? enqueue_hrtimer+0x95/0x9f
 __do_softirq+0x181/0x31f
 irq_exit+0x6a/0x86
smp_apic_timer_interrupt+0x15e/0x183
 apic_timer_interrupt+0xf/0x20
 </IRQ>

We thus should not schedule() at all, even with timeout == 0, this
crashes the kernel.  We can however use try_wait_for_completion()
instead of wait_for_completion_timeout(0).

Cc: stable@vger.kernel.org
Reported-by: John Covici <covici@ccs.covici.com>
Tested-by: John Covici <covici@ccs.covici.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20201108131233.tadycr73sxlvodgo@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/accessibility/speakup/spk_ttyio.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -298,11 +298,13 @@ static unsigned char ttyio_in(int timeou
 	struct spk_ldisc_data *ldisc_data = speakup_tty->disc_data;
 	char rv;
 
-	if (wait_for_completion_timeout(&ldisc_data->completion,
+	if (!timeout) {
+		if (!try_wait_for_completion(&ldisc_data->completion))
+			return 0xff;
+	} else if (wait_for_completion_timeout(&ldisc_data->completion,
 					usecs_to_jiffies(timeout)) == 0) {
-		if (timeout)
-			pr_warn("spk_ttyio: timeout (%d)  while waiting for input\n",
-				timeout);
+		pr_warn("spk_ttyio: timeout (%d)  while waiting for input\n",
+			timeout);
 		return 0xff;
 	}
 



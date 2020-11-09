Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC42ABACC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgKINWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388174AbgKINWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:22:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05E682083B;
        Mon,  9 Nov 2020 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928141;
        bh=M0G466X9KyROxK/ZmhJEsQmpTXTT0u9NemVAF6Vjwbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpfbyfVrTEZK9IzG8YckLPp/jZwdgDW3kIvoRgko8FORotRfvhAE4bTnpXrkz7R7R
         MAL/FK8I8XdnZvUzXdIk3IFw2X/FXRqG0qW7G4UfKV5RkwmwIw/2cz9DrFj1xqPD/0
         A9gNNhi3WgrUg9ZFdmk3GkE38VUL+yYKMc5Vaa+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.9 127/133] ARC: stack unwinding: avoid indefinite looping
Date:   Mon,  9 Nov 2020 13:56:29 +0100
Message-Id: <20201109125036.795970201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 328d2168ca524d501fc4b133d6be076142bd305c upstream.

Currently stack unwinder is a while(1) loop which relies on the dwarf
unwinder to signal termination, which in turn relies on dwarf info to do
so. This in theory could cause an infinite loop if the dwarf info was
somehow messed up or the register contents were etc.

This fix thus detects the excessive looping and breaks the loop.

| Mem: 26184K used, 1009136K free, 0K shrd, 0K buff, 14416K cached
| CPU:  0.0% usr 72.8% sys  0.0% nic 27.1% idle  0.0% io  0.0% irq  0.0% sirq
| Load average: 4.33 2.60 1.11 2/74 139
|   PID  PPID USER     STAT   VSZ %VSZ CPU %CPU COMMAND
|   133     2 root     SWN      0  0.0   3 22.9 [rcu_torture_rea]
|   132     2 root     SWN      0  0.0   0 22.0 [rcu_torture_rea]
|   131     2 root     SWN      0  0.0   3 21.5 [rcu_torture_rea]
|   126     2 root     RW       0  0.0   2  5.4 [rcu_torture_wri]
|   129     2 root     SWN      0  0.0   0  0.2 [rcu_torture_fak]
|   137     2 root     SW       0  0.0   0  0.2 [rcu_torture_cbf]
|   127     2 root     SWN      0  0.0   0  0.1 [rcu_torture_fak]
|   138   115 root     R     1464  0.1   2  0.1 top
|   130     2 root     SWN      0  0.0   0  0.1 [rcu_torture_fak]
|   128     2 root     SWN      0  0.0   0  0.1 [rcu_torture_fak]
|   115     1 root     S     1472  0.1   1  0.0 -/bin/sh
|   104     1 root     S     1464  0.1   0  0.0 inetd
|     1     0 root     S     1456  0.1   2  0.0 init
|    78     1 root     S     1456  0.1   0  0.0 syslogd -O /var/log/messages
|   134     2 root     SW       0  0.0   2  0.0 [rcu_torture_sta]
|    10     2 root     IW       0  0.0   1  0.0 [rcu_preempt]
|    88     2 root     IW       0  0.0   1  0.0 [kworker/1:1-eve]
|    66     2 root     IW       0  0.0   2  0.0 [kworker/2:2-eve]
|    39     2 root     IW       0  0.0   2  0.0 [kworker/2:1-eve]
| unwinder looping too long, aborting !

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/stacktrace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arc/kernel/stacktrace.c
+++ b/arch/arc/kernel/stacktrace.c
@@ -112,7 +112,7 @@ arc_unwind_core(struct task_struct *tsk,
 		int (*consumer_fn) (unsigned int, void *), void *arg)
 {
 #ifdef CONFIG_ARC_DW2_UNWIND
-	int ret = 0;
+	int ret = 0, cnt = 0;
 	unsigned int address;
 	struct unwind_frame_info frame_info;
 
@@ -132,6 +132,11 @@ arc_unwind_core(struct task_struct *tsk,
 			break;
 
 		frame_info.regs.r63 = frame_info.regs.r31;
+
+		if (cnt++ > 128) {
+			printk("unwinder looping too long, aborting !\n");
+			return 0;
+		}
 	}
 
 	return address;		/* return the last address it saw */



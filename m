Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB0A3EB82F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241703AbhHMPLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241862AbhHMPLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ADBE61156;
        Fri, 13 Aug 2021 15:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867441;
        bh=APXV1ettJc56Pim3O9S/zGJB+22qUeFzyCZDhmKV3SY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEUhVqda1m23gjirObloe+r3eud9gBCi54uH+8jBxqORj0Mkus/SLgcddsI9qcZdz
         FSTUkCWUN+Qp+KQRcL42JDaKCEKr5pLqe3lZe+gW8CmKzDxit7ZbLJg6CKl4LJWNeR
         DmNjmPl6Mar5IUzuuggDsWrP2vhOGxa/XPU4JDrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e2eae5639e7203360018@syzkaller.appspotmail.com,
        "Qiang.zhang" <qiang.zhang@windriver.com>,
        Guido Kiener <guido.kiener@rohde-schwarz.com>
Subject: [PATCH 4.14 15/42] USB: usbtmc: Fix RCU stall warning
Date:   Fri, 13 Aug 2021 17:06:41 +0200
Message-Id: <20210813150525.617800151@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang.zhang <qiang.zhang@windriver.com>

commit 30fad76ce4e98263edfa8f885c81d5426c1bf169 upstream.

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    1-...!: (2 ticks this GP) idle=d92/1/0x4000000000000000
        softirq=25390/25392 fqs=3
        (t=12164 jiffies g=31645 q=43226)
rcu: rcu_preempt kthread starved for 12162 jiffies! g31645 f0x0
     RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu:    Unless rcu_preempt kthread gets sufficient CPU time,
        OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task
...........
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: unknown status received: -71
usbtmc 3-1:0.0: usb_submit_urb failed: -19

The function usbtmc_interrupt() resubmits urbs when the error status
of an urb is -EPROTO. In systems using the dummy_hcd usb controller
this can result in endless interrupt loops when the usbtmc device is
disconnected from the host system.

Since host controller drivers already try to recover from transmission
errors, there is no need to resubmit the urb or try other solutions
to repair the error situation.

In case of errors the INT pipe just stops to wait for further packets.

Fixes: dbf3e7f654c0 ("Implement an ioctl to support the USMTMC-USB488 READ_STATUS_BYTE operation")
Cc: stable@vger.kernel.org
Reported-by: syzbot+e2eae5639e7203360018@syzkaller.appspotmail.com
Signed-off-by: Qiang.zhang <qiang.zhang@windriver.com>
Acked-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Link: https://lore.kernel.org/r/20210723004334.458930-1-qiang.zhang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1343,16 +1343,10 @@ static void usbtmc_interrupt(struct urb
 	case -EOVERFLOW:
 		dev_err(dev, "overflow with length %d, actual length is %d\n",
 			data->iin_wMaxPacketSize, urb->actual_length);
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-	case -EILSEQ:
-	case -ETIME:
+	default:
 		/* urb terminated, clean up */
 		dev_dbg(dev, "urb terminated, status: %d\n", status);
 		return;
-	default:
-		dev_err(dev, "unknown status received: %d\n", status);
 	}
 exit:
 	rv = usb_submit_urb(urb, GFP_ATOMIC);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9F91B68F4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgDWXTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:19:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48822 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728243AbgDWXGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:36 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvN-0004dP-L1; Fri, 24 Apr 2020 00:06:29 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-00E6l1-S9; Fri, 24 Apr 2020 00:06:27 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Xiao Jiangfeng" <xiaojiangfeng@huawei.com>,
        "Mao Wenan" <maowenan@huawei.com>
Date:   Fri, 24 Apr 2020 00:05:05 +0100
Message-ID: <lsq.1587683028.285728953@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 078/245] af_packet: set defaule value for tmo
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mao Wenan <maowenan@huawei.com>

commit b43d1f9f7067c6759b1051e8ecb84e82cef569fe upstream.

There is softlockup when using TPACKET_V3:
...
NMI watchdog: BUG: soft lockup - CPU#2 stuck for 60010ms!
(__irq_svc) from [<c0558a0c>] (_raw_spin_unlock_irqrestore+0x44/0x54)
(_raw_spin_unlock_irqrestore) from [<c027b7e8>] (mod_timer+0x210/0x25c)
(mod_timer) from [<c0549c30>]
(prb_retire_rx_blk_timer_expired+0x68/0x11c)
(prb_retire_rx_blk_timer_expired) from [<c027a7ac>]
(call_timer_fn+0x90/0x17c)
(call_timer_fn) from [<c027ab6c>] (run_timer_softirq+0x2d4/0x2fc)
(run_timer_softirq) from [<c021eaf4>] (__do_softirq+0x218/0x318)
(__do_softirq) from [<c021eea0>] (irq_exit+0x88/0xac)
(irq_exit) from [<c0240130>] (msa_irq_exit+0x11c/0x1d4)
(msa_irq_exit) from [<c0209cf0>] (handle_IPI+0x650/0x7f4)
(handle_IPI) from [<c02015bc>] (gic_handle_irq+0x108/0x118)
(gic_handle_irq) from [<c0558ee4>] (__irq_usr+0x44/0x5c)
...

If __ethtool_get_link_ksettings() is failed in
prb_calc_retire_blk_tmo(), msec and tmo will be zero, so tov_in_jiffies
is zero and the timer expire for retire_blk_timer is turn to
mod_timer(&pkc->retire_blk_timer, jiffies + 0),
which will trigger cpu usage of softirq is 100%.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Tested-by: Xiao Jiangfeng <xiaojiangfeng@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -608,7 +608,8 @@ static int prb_calc_retire_blk_tmo(struc
 			msec = 1;
 			div = speed / 1000;
 		}
-	}
+	} else
+		return DEFAULT_PRB_RETIRE_TOV;
 
 	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
 


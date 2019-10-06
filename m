Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B9BCD7BB
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbfJFRdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbfJFRdq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:33:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308AF2087E;
        Sun,  6 Oct 2019 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383224;
        bh=ErQ0RgoWdfW96VS3tVihmJ/1VyvhZfVQSqm01Rnf9Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4CEYZ+n4W2xcXVvIsPyAaYtrNlluPVB1oKdP/ljA5//LgSd3P9vVE7twpJ1Tc+Ct
         OgNWDvM6SpkSQOnjODimD3u/h53IxPak+zhopwqTy02hAU+ygWWdHtbTW4tRaTZnhK
         fRjj9TSBrMW4Er37HZ3BaHvyNSbF/TuENM+7xYRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 025/137] net: sched: taprio: Avoid division by zero on invalid link speed
Date:   Sun,  6 Oct 2019 19:20:09 +0200
Message-Id: <20191006171211.300947133@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 9a9251a3534745d08a92abfeca0ca467b912b5f6 ]

The check in taprio_set_picos_per_byte is currently not robust enough
and will trigger this division by zero, due to e.g. PHYLINK not setting
kset->base.speed when there is no PHY connected:

[   27.109992] Division by zero in kernel.
[   27.113842] CPU: 1 PID: 198 Comm: tc Not tainted 5.3.0-rc5-01246-gc4006b8c2637-dirty #212
[   27.121974] Hardware name: Freescale LS1021A
[   27.126234] [<c03132e0>] (unwind_backtrace) from [<c030d8b8>] (show_stack+0x10/0x14)
[   27.133938] [<c030d8b8>] (show_stack) from [<c10b21b0>] (dump_stack+0xb0/0xc4)
[   27.141124] [<c10b21b0>] (dump_stack) from [<c10af97c>] (Ldiv0_64+0x8/0x18)
[   27.148052] [<c10af97c>] (Ldiv0_64) from [<c0700260>] (div64_u64+0xcc/0xf0)
[   27.154978] [<c0700260>] (div64_u64) from [<c07002d0>] (div64_s64+0x4c/0x68)
[   27.161993] [<c07002d0>] (div64_s64) from [<c0f3d890>] (taprio_set_picos_per_byte+0xe8/0xf4)
[   27.170388] [<c0f3d890>] (taprio_set_picos_per_byte) from [<c0f3f614>] (taprio_change+0x668/0xcec)
[   27.179302] [<c0f3f614>] (taprio_change) from [<c0f2bc24>] (qdisc_create+0x1fc/0x4f4)
[   27.187091] [<c0f2bc24>] (qdisc_create) from [<c0f2c0c8>] (tc_modify_qdisc+0x1ac/0x6f8)
[   27.195055] [<c0f2c0c8>] (tc_modify_qdisc) from [<c0ee9604>] (rtnetlink_rcv_msg+0x268/0x2dc)
[   27.203449] [<c0ee9604>] (rtnetlink_rcv_msg) from [<c0f4fef0>] (netlink_rcv_skb+0xe0/0x114)
[   27.211756] [<c0f4fef0>] (netlink_rcv_skb) from [<c0f4f6cc>] (netlink_unicast+0x1b4/0x22c)
[   27.219977] [<c0f4f6cc>] (netlink_unicast) from [<c0f4fa84>] (netlink_sendmsg+0x284/0x340)
[   27.228198] [<c0f4fa84>] (netlink_sendmsg) from [<c0eae5fc>] (sock_sendmsg+0x14/0x24)
[   27.235988] [<c0eae5fc>] (sock_sendmsg) from [<c0eaedf8>] (___sys_sendmsg+0x214/0x228)
[   27.243863] [<c0eaedf8>] (___sys_sendmsg) from [<c0eb015c>] (__sys_sendmsg+0x50/0x8c)
[   27.251652] [<c0eb015c>] (__sys_sendmsg) from [<c0301000>] (ret_fast_syscall+0x0/0x54)
[   27.259524] Exception stack(0xe8045fa8 to 0xe8045ff0)
[   27.264546] 5fa0:                   b6f608c8 000000f8 00000003 bed7e2f0 00000000 00000000
[   27.272681] 5fc0: b6f608c8 000000f8 004ce54c 00000128 5d3ce8c7 00000000 00000026 00505c9c
[   27.280812] 5fe0: 00000070 bed7e298 004ddd64 b6dd1e64

Russell King points out that the ethtool API says zero is a valid return
value of __ethtool_get_link_ksettings:

   * If it is enabled then they are read-only; if the link
   * is up they represent the negotiated link mode; if the link is down,
   * the speed is 0, %SPEED_UNKNOWN or the highest enabled speed and
   * @duplex is %DUPLEX_UNKNOWN or the best enabled duplex mode.

  So, it seems that taprio is not following the API... I'd suggest either
  fixing taprio, or getting agreement to change the ethtool API.

The chosen path was to fix taprio.

Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -668,7 +668,7 @@ static void taprio_set_picos_per_byte(st
 	if (err < 0)
 		goto skip;
 
-	if (ecmd.base.speed != SPEED_UNKNOWN)
+	if (ecmd.base.speed && ecmd.base.speed != SPEED_UNKNOWN)
 		speed = ecmd.base.speed;
 
 skip:



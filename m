Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C241578FE
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgBJNLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgBJMi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B03C020842;
        Mon, 10 Feb 2020 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338336;
        bh=pBNVe5B5TuxLtTBe56iYx6Q7FVo7ZnEtWgxBdzTyK7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8lqpPDU51GpKSyESEA/pt1nFMlFC01aHHyrnin/aVJit8QdkQrXCc92yJErtMN5D
         DYuyaLzYqKETaH19q4Rs3/PpNzoB5zQH7sEg8deTSLmeokyjcCSw6eiiIU79351sfI
         j+99+GqaTyBdyrpcVBZbcp9DXSupC/5IDD4zDlI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 284/309] drop_monitor: Do not cancel uninitialized work item
Date:   Mon, 10 Feb 2020 04:34:00 -0800
Message-Id: <20200210122433.937537135@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit dfa7f709596be5ca46c070d4f8acbb344322056a ]

Drop monitor uses a work item that takes care of constructing and
sending netlink notifications to user space. In case drop monitor never
started to monitor, then the work item is uninitialized and not
associated with a function.

Therefore, a stop command from user space results in canceling an
uninitialized work item which leads to the following warning [1].

Fix this by not processing a stop command if drop monitor is not
currently monitoring.

[1]
[   31.735402] ------------[ cut here ]------------
[   31.736470] WARNING: CPU: 0 PID: 143 at kernel/workqueue.c:3032 __flush_work+0x89f/0x9f0
...
[   31.738120] CPU: 0 PID: 143 Comm: dwdump Not tainted 5.5.0-custom-09491-g16d4077796b8 #727
[   31.741968] RIP: 0010:__flush_work+0x89f/0x9f0
...
[   31.760526] Call Trace:
[   31.771689]  __cancel_work_timer+0x2a6/0x3b0
[   31.776809]  net_dm_cmd_trace+0x300/0xef0
[   31.777549]  genl_rcv_msg+0x5c6/0xd50
[   31.781005]  netlink_rcv_skb+0x13b/0x3a0
[   31.784114]  genl_rcv+0x29/0x40
[   31.784720]  netlink_unicast+0x49f/0x6a0
[   31.787148]  netlink_sendmsg+0x7cf/0xc80
[   31.790426]  ____sys_sendmsg+0x620/0x770
[   31.793458]  ___sys_sendmsg+0xfd/0x170
[   31.802216]  __sys_sendmsg+0xdf/0x1a0
[   31.806195]  do_syscall_64+0xa0/0x540
[   31.806885]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 8e94c3bc922e ("drop_monitor: Allow user to start monitoring hardware drops")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/drop_monitor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1004,8 +1004,10 @@ static void net_dm_hw_monitor_stop(struc
 {
 	int cpu;
 
-	if (!monitor_hw)
+	if (!monitor_hw) {
 		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already disabled");
+		return;
+	}
 
 	monitor_hw = false;
 



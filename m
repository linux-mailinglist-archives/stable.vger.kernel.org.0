Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B624B66CBF3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbjAPRUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbjAPRT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4AF367F1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE1B61083
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD64C433EF;
        Mon, 16 Jan 2023 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888345;
        bh=XvE9Tz/9lLTpB/lBLTWPlTQZ71831ZYvD5SuOeXkfto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrbf32YT2sNLGmgdlNzSk4sRxyczic+y4TsZ9Nn+I6Sigt8s1Xqz1aPQ1NN3bkifh
         9/2zNmTPGp25k53JLbN6IlIokQaeyvmeIZDW03YMVtaP8x/Rwhh3CK6+eP9zij51JZ
         AcJ0UveXY1YQpJF/JXUhys+wtxNY09mLOIWMcOHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frederick Lawler <fred@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 463/521] net: sched: disallow noqueue for qdisc classes
Date:   Mon, 16 Jan 2023 16:52:05 +0100
Message-Id: <20230116154907.861424231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederick Lawler <fred@cloudflare.com>

commit 96398560f26aa07e8f2969d73c8197e6a6d10407 upstream.

While experimenting with applying noqueue to a classful queue discipline,
we discovered a NULL pointer dereference in the __dev_queue_xmit()
path that generates a kernel OOPS:

    # dev=enp0s5
    # tc qdisc replace dev $dev root handle 1: htb default 1
    # tc class add dev $dev parent 1: classid 1:1 htb rate 10mbit
    # tc qdisc add dev $dev parent 1:1 handle 10: noqueue
    # ping -I $dev -w 1 -c 1 1.1.1.1

[    2.172856] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    2.173217] #PF: supervisor instruction fetch in kernel mode
...
[    2.178451] Call Trace:
[    2.178577]  <TASK>
[    2.178686]  htb_enqueue+0x1c8/0x370
[    2.178880]  dev_qdisc_enqueue+0x15/0x90
[    2.179093]  __dev_queue_xmit+0x798/0xd00
[    2.179305]  ? _raw_write_lock_bh+0xe/0x30
[    2.179522]  ? __local_bh_enable_ip+0x32/0x70
[    2.179759]  ? ___neigh_create+0x610/0x840
[    2.179968]  ? eth_header+0x21/0xc0
[    2.180144]  ip_finish_output2+0x15e/0x4f0
[    2.180348]  ? dst_output+0x30/0x30
[    2.180525]  ip_push_pending_frames+0x9d/0xb0
[    2.180739]  raw_sendmsg+0x601/0xcb0
[    2.180916]  ? _raw_spin_trylock+0xe/0x50
[    2.181112]  ? _raw_spin_unlock_irqrestore+0x16/0x30
[    2.181354]  ? get_page_from_freelist+0xcd6/0xdf0
[    2.181594]  ? sock_sendmsg+0x56/0x60
[    2.181781]  sock_sendmsg+0x56/0x60
[    2.181958]  __sys_sendto+0xf7/0x160
[    2.182139]  ? handle_mm_fault+0x6e/0x1d0
[    2.182366]  ? do_user_addr_fault+0x1e1/0x660
[    2.182627]  __x64_sys_sendto+0x1b/0x30
[    2.182881]  do_syscall_64+0x38/0x90
[    2.183085]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
...
[    2.187402]  </TASK>

Previously in commit d66d6c3152e8 ("net: sched: register noqueue
qdisc"), NULL was set for the noqueue discipline on noqueue init
so that __dev_queue_xmit() falls through for the noqueue case. This
also sets a bypass of the enqueue NULL check in the
register_qdisc() function for the struct noqueue_disc_ops.

Classful queue disciplines make it past the NULL check in
__dev_queue_xmit() because the discipline is set to htb (in this case),
and then in the call to __dev_xmit_skb(), it calls into htb_enqueue()
which grabs a leaf node for a class and then calls qdisc_enqueue() by
passing in a queue discipline which assumes ->enqueue() is not set to NULL.

Fix this by not allowing classes to be assigned to the noqueue
discipline. Linux TC Notes states that classes cannot be set to
the noqueue discipline. [1] Let's enforce that here.

Links:
1. https://linux-tc-notes.sourceforge.net/tc/doc/sch_noqueue.txt

Fixes: d66d6c3152e8 ("net: sched: register noqueue qdisc")
Cc: stable@vger.kernel.org
Signed-off-by: Frederick Lawler <fred@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20230109163906.706000-1-fred@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1031,8 +1031,12 @@ skip:
 			unsigned long cl = cops->find(parent, classid);
 
 			if (cl) {
-				err = cops->graft(parent, cl, new, &old,
-						  extack);
+				if (new && new->ops == &noqueue_qdisc_ops) {
+					NL_SET_ERR_MSG(extack, "Cannot assign noqueue to a class");
+					err = -EINVAL;
+				} else {
+					err = cops->graft(parent, cl, new, &old, extack);
+				}
 			} else {
 				NL_SET_ERR_MSG(extack, "Specified class not found");
 				err = -ENOENT;



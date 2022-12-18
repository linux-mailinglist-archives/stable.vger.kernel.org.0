Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80564650265
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbiLRQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiLRQpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:45:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FEC101FC;
        Sun, 18 Dec 2022 08:16:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D21C260DC9;
        Sun, 18 Dec 2022 16:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F48C433D2;
        Sun, 18 Dec 2022 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380178;
        bh=FSsv1Qt4W1/uQvi48LAPtdUt7iKXNJabjclblcQa16o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7LZ3hfK9tP5AktsxXuRjsFVQyC+wIJnlr1NTd/vEmhP6P/85mGmhfm1VkH2QKd7N
         La1hKOo3M9mPlyNyxD78hleNVCK+aA74fEpXrv3IzzDqnE6HtOIlTH2lcjkSoPOXyI
         zD/ITaygBfERyMKMsLOxQCNL72IfWAeWe5QcUbiZtCvsusGD2sQKInWKs7iBBiTRNq
         szuzTcezVPrZ8/2wJv/78lO4HhWzeNBMIAY0NC4aJlwB22zhWKTC+4MttQBeT0cTjD
         oDa2J19vX5wVb6FRbvcw3paBaDof/U931uiGWAwGowx4qL/pXt41zZN31NKav1zk0W
         J9B/Hktjk0Nhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Yuchen <zhangyuchen.lcr@bytedance.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 06/39] ipmi: fix memleak when unload ipmi driver
Date:   Sun, 18 Dec 2022 11:15:26 -0500
Message-Id: <20221218161559.932604-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>

[ Upstream commit 36992eb6b9b83f7f9cdc8e74fb5799d7b52e83e9 ]

After the IPMI disconnect problem, the memory kept rising and we tried
to unload the driver to free the memory. However, only part of the
free memory is recovered after the driver is uninstalled. Using
ebpf to hook free functions, we find that neither ipmi_user nor
ipmi_smi_msg is free, only ipmi_recv_msg is free.

We find that the deliver_smi_err_response call in clean_smi_msgs does
the destroy processing on each message from the xmit_msg queue without
checking the return value and free ipmi_smi_msg.

deliver_smi_err_response is called only at this location. Adding the
free handling has no effect.

To verify, try using ebpf to trace the free function.

  $ bpftrace -e 'kretprobe:ipmi_alloc_recv_msg {printf("alloc rcv
      %p\n",retval);} kprobe:free_recv_msg {printf("free recv %p\n",
      arg0)} kretprobe:ipmi_alloc_smi_msg {printf("alloc smi %p\n",
        retval);} kprobe:free_smi_msg {printf("free smi  %p\n",arg0)}'

Signed-off-by: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
Message-Id: <20221007092617.87597-4-zhangyuchen.lcr@bytedance.com>
[Fixed the comment above handle_one_recv_msg().]
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 05e7339752ac..223b90247648 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3540,12 +3540,16 @@ static void deliver_smi_err_response(struct ipmi_smi *intf,
 				     struct ipmi_smi_msg *msg,
 				     unsigned char err)
 {
+	int rv;
 	msg->rsp[0] = msg->data[0] | 4;
 	msg->rsp[1] = msg->data[1];
 	msg->rsp[2] = err;
 	msg->rsp_size = 3;
-	/* It's an error, so it will never requeue, no need to check return. */
-	handle_one_recv_msg(intf, msg);
+
+	/* This will never requeue, but it may ask us to free the message. */
+	rv = handle_one_recv_msg(intf, msg);
+	if (rv == 0)
+		ipmi_free_smi_msg(msg);
 }
 
 static void cleanup_smi_msgs(struct ipmi_smi *intf)
-- 
2.35.1


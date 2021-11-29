Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAFD46163F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhK2N3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:29:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377836AbhK2N1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:27:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A350614E0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75AC004E1;
        Mon, 29 Nov 2021 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638192227;
        bh=ef46TBPrQuSO3SAqj6YbbICRbvhcea+9mPOWZ2KFUxw=;
        h=Subject:To:Cc:From:Date:From;
        b=W/pV5RMMy9gdn0HdRFOmZ+76cl2meP3Do6JIDcvjD72jFR79ZYCz1YmHK/ciJjJLo
         AyX4q1DYPV/ix8C5eWOyxw5wBXOMg+NnkeVbvc8QtKtAlp6mCiQWmLn2frks39SXOS
         m56qf7uPjH5JQeYt87v7rWNjZBJwkTC4OHbnP1/s=
Subject: FAILED: patch "[PATCH] net/smc: Fix loop in smc_listen" failed to apply to 4.14-stable tree
To:     guodaxing@huawei.com, kgraul@linux.ibm.com, kuba@kernel.org,
        tonylu@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 14:23:37 +0100
Message-ID: <1638192217471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9ebb0c4b27a6158303b791b5b91e66d7665ee30e Mon Sep 17 00:00:00 2001
From: Guo DaXing <guodaxing@huawei.com>
Date: Wed, 24 Nov 2021 13:32:38 +0100
Subject: [PATCH] net/smc: Fix loop in smc_listen

The kernel_listen function in smc_listen will fail when all the available
ports are occupied.  At this point smc->clcsock->sk->sk_data_ready has
been changed to smc_clcsock_data_ready.  When we call smc_listen again,
now both smc->clcsock->sk->sk_data_ready and smc->clcsk_data_ready point
to the smc_clcsock_data_ready function.

The smc_clcsock_data_ready() function calls lsmc->clcsk_data_ready which
now points to itself resulting in an infinite loop.

This patch restores smc->clcsock->sk->sk_data_ready with the old value.

Fixes: a60a2b1e0af1 ("net/smc: reduce active tcp_listen workers")
Signed-off-by: Guo DaXing <guodaxing@huawei.com>
Acked-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 2692cba5a7b6..4b62c925a13e 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2134,8 +2134,10 @@ static int smc_listen(struct socket *sock, int backlog)
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	rc = kernel_listen(smc->clcsock, backlog);
-	if (rc)
+	if (rc) {
+		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
 		goto out;
+	}
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 	sk->sk_state = SMC_LISTEN;


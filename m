Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5976D461644
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240208AbhK2N3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:29:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56958 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377843AbhK2N1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE471B8111B
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007AEC004E1;
        Mon, 29 Nov 2021 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638192233;
        bh=jtakV04xOuKDOFijUJh7POUehH3h2cqa75ErJeH+bxE=;
        h=Subject:To:Cc:From:Date:From;
        b=Y1OoQKie93F0x1Cam8OmZlQxgnSMiPsLtWAvEMdocwhoICkaTIGIORqEVfAKRxrQt
         cPV97jrXNt/Wl7BopPOI7ZZYmP/102J9/2mr0XgQ44BoleBA4MsIeG3UP64/Oe8lcd
         SaazaVu5KHQal1jY5McusCyj0kRgB+iriIggZssw=
Subject: FAILED: patch "[PATCH] net/smc: Fix loop in smc_listen" failed to apply to 5.4-stable tree
To:     guodaxing@huawei.com, kgraul@linux.ibm.com, kuba@kernel.org,
        tonylu@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 14:23:38 +0100
Message-ID: <163819221813716@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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


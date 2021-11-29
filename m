Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C659A46263B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhK2WtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhK2Ws2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:48:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AFFC1A3CBB;
        Mon, 29 Nov 2021 10:40:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2D704CE13F9;
        Mon, 29 Nov 2021 18:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC86C53FC7;
        Mon, 29 Nov 2021 18:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211199;
        bh=9uDJZWRHXsy9GJI11f09uM5MJFIW9TJiQ8R1goVqPXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GItah4iW9sspPKnd/CV8xEifNwj4q+g/E24XhsBr0Mc54vV7/tYzr+oAmktMV29VF
         AdDS5d5o6YKZsULAieiOG0+oCHw4NSHjS313iBgmv2d+m1AtQLTSAfuH1BkF4DXcq/
         tZc87WWQ2N3Nj4UcbfMIMolBKP94MuZQILDS66yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guo DaXing <guodaxing@huawei.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/179] net/smc: Fix loop in smc_listen
Date:   Mon, 29 Nov 2021 19:18:52 +0100
Message-Id: <20211129181723.494735706@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo DaXing <guodaxing@huawei.com>

[ Upstream commit 9ebb0c4b27a6158303b791b5b91e66d7665ee30e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 32c1c7ce856d3..4f1fa1bcb0316 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1918,8 +1918,10 @@ static int smc_listen(struct socket *sock, int backlog)
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
-- 
2.33.0




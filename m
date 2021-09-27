Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE000419BF2
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhI0RY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237033AbhI0RVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF1861368;
        Mon, 27 Sep 2021 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762833;
        bh=EqNE58TLdnbDUxe87QGjrPr5OBLTMiA0FpOunNK2YQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eefV5IqYdgYxKVloGXj7azXi0bUTX1t+zYO4PT7p5wTpy5eE2xEvWjT+znJCgutZd
         b9eV7LGoJ92dkVCIYq39OnGu5rRM39j3lWbYwLtn58SQZbW/ePUAfZWZ+40MJ4NsOD
         fE25L3qeRiBK/110a0agPDqHvdqcOh1TbPnq19Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 069/162] net/smc: add missing error check in smc_clc_prfx_set()
Date:   Mon, 27 Sep 2021 19:01:55 +0200
Message-Id: <20210927170235.853649009@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 6c90731980655280ea07ce4b21eb97457bf86286 ]

Coverity stumbled over a missing error check in smc_clc_prfx_set():

*** CID 1475954:  Error handling issues  (CHECKED_RETURN)
/net/smc/smc_clc.c: 233 in smc_clc_prfx_set()
>>>     CID 1475954:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "kernel_getsockname" without checking return value (as is done elsewhere 8 out of 10 times).
233     	kernel_getsockname(clcsock, (struct sockaddr *)&addrs);

Add the return code check in smc_clc_prfx_set().

Fixes: c246d942eabc ("net/smc: restructure netinfo for CLC proposal msgs")
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index e286dafd6e88..6ec1ebe878ae 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -230,7 +230,8 @@ static int smc_clc_prfx_set(struct socket *clcsock,
 		goto out_rel;
 	}
 	/* get address to which the internal TCP socket is bound */
-	kernel_getsockname(clcsock, (struct sockaddr *)&addrs);
+	if (kernel_getsockname(clcsock, (struct sockaddr *)&addrs) < 0)
+		goto out_rel;
 	/* analyze IP specific data of net_device belonging to TCP socket */
 	addr6 = (struct sockaddr_in6 *)&addrs;
 	rcu_read_lock();
-- 
2.33.0




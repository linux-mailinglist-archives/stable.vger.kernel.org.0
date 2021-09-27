Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D8419A18
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhI0RGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235993AbhI0RGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2B1A610E8;
        Mon, 27 Sep 2021 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762278;
        bh=GNIlfP3d2JHCkz2BqfOk+aNMXJf7TAQzElxBLBizsus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqbp2Vbb9Wtwycnk2qQpmxJfgt40pV9/ne7o2ITss8+zFo7oFrsX8Yng2tpoM2quP
         mQobG+ltMwvf7ZG1z6PTxyLI+Gm1SazOkOoQ9kWIA3oR0CbP2z/V7BT4u378rcV0OQ
         uCK3wV6784fmna4k+HD3hfqPJc+5601CSIdvZRp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/68] net/smc: add missing error check in smc_clc_prfx_set()
Date:   Mon, 27 Sep 2021 19:02:25 +0200
Message-Id: <20210927170220.977286169@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
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
index aee9ccfa99c2..ade1232699bb 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -164,7 +164,8 @@ static int smc_clc_prfx_set(struct socket *clcsock,
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




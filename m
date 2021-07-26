Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17633D6142
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhGZPa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236687AbhGZP3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3B66101E;
        Mon, 26 Jul 2021 16:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315648;
        bh=mI38fLHm9QiqKCocEnN/NSDEGj/6ubCX7Ie3xSJpOxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDrWoTvWnQSY9OlHlKAUu8OqfJp0pVJmR6vzAAPl1XVvCyyp3cVo+G4qw+Jnz3Y8Q
         4VVG0mWKVwJE3QHTrBsdIRkiuFveito/LxOQhBOPYxfv5a/7SYPkJwxkLU3IgX1vD9
         lsxM4AUg1a8bm3cAFJTk1/4OgubWL9FUzBYT7+kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 012/223] net: stmmac: Terminate FPE workqueue in suspend
Date:   Mon, 26 Jul 2021 17:36:44 +0200
Message-Id: <20210726153846.664489877@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

[ Upstream commit 6b28a86d6c0bb02119f386ec2f56efde909e9bcb ]

Add stmmac_fpe_stop_wq() in stmmac_suspend() to terminate FPE workqueue
during suspend. So, in suspend mode, there will be no FPE workqueue
available. Without this fix, new additional FPE workqueue will be created
in every suspend->resume cycle.

Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner hand-shaking procedure")
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 91cd5073ddb2..980a60477b02 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7170,6 +7170,7 @@ int stmmac_suspend(struct device *dev)
 				     priv->plat->rx_queues_to_use, false);
 
 		stmmac_fpe_handshake(priv, false);
+		stmmac_fpe_stop_wq(priv);
 	}
 
 	priv->speed = SPEED_UNKNOWN;
-- 
2.30.2




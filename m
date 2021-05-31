Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1786A39606E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhEaO0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232167AbhEaOYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D331A61428;
        Mon, 31 May 2021 13:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468767;
        bh=W4hzXqoHG/3EjJjFlzLnc/9WzCpZO4RrGgLy7YdQrX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjArtL8cRzgQ7b3JJFt9Wal95lp1SbGjRKsFNEmkBFHGCefJPAH8NQDzn7mwkJMwi
         fuOMCoROdKy8FFEDz+197WfCWtY7p9Vdm436I2S/rMSGYd2JQpupGXd9qRAGfzK954
         HidsQxF4MjULukjQnfG1pnm+amoSyYK0NGOFHaU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/177] Revert "net: liquidio: fix a NULL pointer dereference"
Date:   Mon, 31 May 2021 15:14:36 +0200
Message-Id: <20210531130652.029137227@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 4fd798a5a89114c1892574c50f2aebd49bc5b4f5 ]

This reverts commit fe543b2f174f34a7a751aa08b334fe6b105c4569.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While the original commit does keep the immediate "NULL dereference"
from happening, it does not properly propagate the error back to the
callers, AND it does not fix this same identical issue in the
drivers/net/ethernet/cavium/liquidio/lio_vf_main.c for some reason.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-65-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7f3b2e3b0868..f2d486583e2f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1192,11 +1192,6 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	sc = (struct octeon_soft_command *)
 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,
 					  16, 0);
-	if (!sc) {
-		netif_info(lio, rx_err, lio->netdev,
-			   "Failed to allocate octeon_soft_command\n");
-		return;
-	}
 
 	ncmd = (union octnet_cmd *)sc->virtdptr;
 
-- 
2.30.2




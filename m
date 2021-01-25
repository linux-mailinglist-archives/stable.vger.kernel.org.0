Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90E7302AAB
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbhAYSrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727287AbhAYSrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53CC3207B3;
        Mon, 25 Jan 2021 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600419;
        bh=vYsC0gqdQq06cgoQOpMyq5CWgPbVWA1Bwdlpt+wZp8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NRPtwvmQ7Upg0+ztBvD3J2XqPhARul5EsdgcfL0XivPTIH/zcgcI58U5eRa9oo3Zw
         +MC2a42cseJ9J+BmXVqqk64P3LqAoxnMpHTy7MwZewRWPOGYYw6tRCZ2bnZCW8RNuu
         2xqgC0eT4dA4vOClBPYh2ZdbMmWAWTRGYTfJUr38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 72/86] sh_eth: Fix power down vs. is_opened flag ordering
Date:   Mon, 25 Jan 2021 19:39:54 +0100
Message-Id: <20210125183204.090410046@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit f6a2e94b3f9d89cb40771ff746b16b5687650cbb upstream.

sh_eth_close() does a synchronous power down of the device before
marking it closed.  Revert the order, to make sure the device is never
marked opened while suspended.

While at it, use pm_runtime_put() instead of pm_runtime_put_sync(), as
there is no reason to do a synchronous power down.

Fixes: 7fa2955ff70ce453 ("sh_eth: Fix sleeping function called from invalid context")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20210118150812.796791-1-geert+renesas@glider.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/renesas/sh_eth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2640,10 +2640,10 @@ static int sh_eth_close(struct net_devic
 	/* Free all the skbuffs in the Rx queue and the DMA buffer. */
 	sh_eth_ring_free(ndev);
 
-	pm_runtime_put_sync(&mdp->pdev->dev);
-
 	mdp->is_opened = 0;
 
+	pm_runtime_put(&mdp->pdev->dev);
+
 	return 0;
 }
 



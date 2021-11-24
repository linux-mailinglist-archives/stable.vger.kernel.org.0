Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0E945C6FD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350802AbhKXORV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:17:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349344AbhKXOQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E39726159A;
        Wed, 24 Nov 2021 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758524;
        bh=/7opcFxqInDxfkd75BaBPF5qCWY1Nf8zpI7LSBxZndk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4uSFJ8JufIhk6FxJ43/A+JOgbtos8xXoHFd7CP27hVrZkurwKClWT3ETmi/XFB5t
         it0uhLA/9XtVu0UN6zAU2v2WXXfCu/6BhItWdXFfihzjZLqXM7HgTfTB131cIEiTBY
         u9gJ2rbisazvNPac36PiGis9WDwm3sIVMhpEqJxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/154] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Date:   Wed, 24 Nov 2021 12:58:14 +0100
Message-Id: <20211124115705.464830083@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9b5a333272a48c2f8b30add7a874e46e8b26129c ]

Access to netdev after free_netdev() will cause use-after-free bug.
Move debug log before free_netdev() call to avoid it.

Fixes: 7472dd9f6499 ("staging: fsl-dpaa2/eth: Move print message")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f91c67489e629..a4ef35216e2f7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4432,10 +4432,10 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	fsl_mc_portal_free(priv->mc_io);
 
-	free_netdev(net_dev);
-
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
+	free_netdev(net_dev);
+
 	return 0;
 }
 
-- 
2.33.0




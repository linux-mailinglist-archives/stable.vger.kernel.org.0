Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA1D22F14E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgG0OUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731042AbgG0OUn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFFEE20775;
        Mon, 27 Jul 2020 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859643;
        bh=8uOWQna+xF+wALsfQe81pslny6LeDhpRhdbY+HKlN6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4KEfb+MhD/+8dIa9zdT8MCzj8fgcwDm7g86oHthV824sVY9elcIezQW2xXSVbFAH
         LRFBr+kFCIUQUog9YSYp48Q/RV2siNq0G0DkvHgsgJiaRU0kK/dMEO57w/sa1SCKyA
         fv2zBwIV5eTMNuMzLjdCVg0Z6WMShidsy6aCjwGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 048/179] hippi: Fix a size used in a pci_free_consistent() in an error handling path
Date:   Mon, 27 Jul 2020 16:03:43 +0200
Message-Id: <20200727134935.008020495@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3195c4706b00106aa82c73acd28340fa8fc2bfc1 ]

The size used when calling 'pci_alloc_consistent()' and
'pci_free_consistent()' should match.

Fix it and have it consistent with the corresponding call in 'rr_close()'.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hippi/rrunner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 2a6ec53949666..a4b3fce69ecd9 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1242,7 +1242,7 @@ static int rr_open(struct net_device *dev)
 		rrpriv->info = NULL;
 	}
 	if (rrpriv->rx_ctrl) {
-		pci_free_consistent(pdev, sizeof(struct ring_ctrl),
+		pci_free_consistent(pdev, 256 * sizeof(struct ring_ctrl),
 				    rrpriv->rx_ctrl, rrpriv->rx_ctrl_dma);
 		rrpriv->rx_ctrl = NULL;
 	}
-- 
2.25.1




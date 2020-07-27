Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2356F22F250
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgG0OjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgG0OKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F9852083E;
        Mon, 27 Jul 2020 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858999;
        bh=JSY/ZG6E/SThjrRqN49pp2TkyzumB4ywJMpDltI+IAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJW9axA9Ga3x2J66eniy2WIqGb/o4hE0YMAftk4Iu1OQrGz0cSto2aLwD+FhqJDL3
         4SlSON38m2BLdmSWjDQNFmd8JyAjeShPVwLBLemm60HK66B/Ftwe2sjEv/FF0XoJMI
         jvySwhQpuNXuCaDl6hQ9JJs503t3g17/1IWqu3Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/86] hippi: Fix a size used in a pci_free_consistent() in an error handling path
Date:   Mon, 27 Jul 2020 16:04:01 +0200
Message-Id: <20200727134915.816999436@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
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
index 029206e4da3b3..2a8c33abb363a 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -1248,7 +1248,7 @@ static int rr_open(struct net_device *dev)
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




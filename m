Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED03D5F32
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhGZPRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237402AbhGZPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B5E61038;
        Mon, 26 Jul 2021 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314901;
        bh=XPnrX+f/6E7NSm+/PmkJUA07/2AB7rk1T6Ys75osYWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBc1vaNb8C5onxff0hWQxt3vkCZ5IhQ9njQHSTJRrVgeqY0opT8qIUk934UbHNq5j
         aa/H5qQPCactzivQepTsX1ZlMGvozV3G6fvaU4UctnJ73PuegrKW0BVyFT7p615n2O
         UMzt5y9fHrN8YZSyGA8Mnea1QmO+5ioOnQgvlpJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/108] gve: Fix an error handling path in gve_probe()
Date:   Mon, 26 Jul 2021 17:38:14 +0200
Message-Id: <20210726153832.125824796@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2342ae10d1272d411a468a85a67647dd115b344f ]

If the 'register_netdev() call fails, we must release the resources
allocated by the previous 'gve_init_priv()' call, as already done in the
remove function.

Add a new label and the missing 'gve_teardown_priv_resources()' in the
error handling path.

Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 1c4b35b1b359..f8dfa7501f65 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1170,13 +1170,16 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = register_netdev(dev);
 	if (err)
-		goto abort_with_wq;
+		goto abort_with_gve_init;
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
 
+abort_with_gve_init:
+	gve_teardown_priv_resources(priv);
+
 abort_with_wq:
 	destroy_workqueue(priv->gve_wq);
 
-- 
2.30.2




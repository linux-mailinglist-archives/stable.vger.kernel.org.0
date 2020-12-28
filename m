Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310562E4050
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392155AbgL1Ot4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:49:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437948AbgL1OVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B7722CB9;
        Mon, 28 Dec 2020 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165255;
        bh=xDlOt0jpK9eElgV1QaTMzGTGvnCs2EIRpHJLnub4fic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vaDMMUMlVuPm6blIskmFvbjSPR4qvuYPt+hFmSY4rM5vVNoSmu+xipkx+1VBalU9N
         ky0VQVKReHZHC2DZOy5Wp9KnnZ20qzMvu5r90lOM39MX2OtCQXn1ia5FkLNITHgb9d
         ghcdAdKy5cQsuWdpr4lw6lwll2OImYQrTXwn5WOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/717] net: mscc: ocelot: Fix a resource leak in the error handling path of the probe function
Date:   Mon, 28 Dec 2020 13:47:45 +0100
Message-Id: <20201228125043.345137184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f87675b836b324d270fd52f1f5e6d6bb9f4bd1d5 ]

In case of error after calling 'ocelot_init()', it must be undone by a
corresponding 'ocelot_deinit()' call, as already done in the remove
function.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20201213114838.126922-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 1e7729421a825..9cf2bc5f42892 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1267,7 +1267,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	err = mscc_ocelot_init_ports(pdev, ports);
 	if (err)
-		goto out_put_ports;
+		goto out_ocelot_deinit;
 
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
@@ -1282,8 +1282,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 
+	of_node_put(ports);
+
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
+	return 0;
+
+out_ocelot_deinit:
+	ocelot_deinit(ocelot);
 out_put_ports:
 	of_node_put(ports);
 	return err;
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF96469DE4
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376570AbhLFPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387156AbhLFPas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CC3C08EE1B;
        Mon,  6 Dec 2021 07:18:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B88BB8101B;
        Mon,  6 Dec 2021 15:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A602C341C1;
        Mon,  6 Dec 2021 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803905;
        bh=k4TnQy9WT+XjXoUhNAoZFOz2DcHOWdK4HcA31fdqCOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk4NR0p91ndRJqLXTBo8Ex4faVR69P1ycu6jbP4UWVW5r0+PpIPk/Q0VtMH3GI1ao
         dkGxtFXf/4Po/GOzbievuWIm8PNBqtwGAGWK9Hc8vl43PdqEJERvWuY6HRv2A/meZb
         P9WfXXfjvhMyo3qtOqas1Sr/1KyNfsRC9ZMnYWWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 088/130] dpaa2-eth: destroy workqueue at the end of remove function
Date:   Mon,  6 Dec 2021 15:56:45 +0100
Message-Id: <20211206145602.702777267@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit f4a8adbfe4841491b60c14fe610571e1422359f9 upstream.

The commit c55211892f46 ("dpaa2-eth: support PTP Sync packet one-step
timestamping") forgets to destroy workqueue at the end of remove
function.

Fix this by adding destroy_workqueue before fsl_mc_portal_free and
free_netdev.

Fixes: c55211892f46 ("dpaa2-eth: support PTP Sync packet one-step timestamping")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4432,6 +4432,8 @@ static int dpaa2_eth_remove(struct fsl_m
 
 	fsl_mc_portal_free(priv->mc_io);
 
+	destroy_workqueue(priv->dpaa2_ptp_wq);
+
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
 	free_netdev(net_dev);



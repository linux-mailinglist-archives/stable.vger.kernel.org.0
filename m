Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4232412EC69
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgABWSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbgABWSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43A522314;
        Thu,  2 Jan 2020 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003488;
        bh=hn6SkEALJClizTIH2eCblKoETrLMCQSOAV0rawGf+38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrJUWkpWoUMaCw7CstoGFO0QOYXuLGbwIIMpVuUn/deDLjBC4PtIf4C1ieiXcjVU1
         eQVffI8XjDpBuKFuLPPfN6NWSHWZxmBghUB32xRqCsyDd+OWyYY6n8FcOU5cGLqymP
         FhiAN30wn8qz0KdLlq6XKR+MQwl9SDFVA/jAvj8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 182/191] hv_netvsc: Fix tx_table init in rndis_set_subchannel()
Date:   Thu,  2 Jan 2020 23:07:44 +0100
Message-Id: <20200102215848.858098357@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit c39ea5cba5a2e97fc01b78c85208bf31383b399c ]

Host can provide send indirection table messages anytime after RSS is
enabled by calling rndis_filter_set_rss_param(). So the host provided
table values may be overwritten by the initialization in
rndis_set_subchannel().

To prevent this problem, move the tx_table initialization before calling
rndis_filter_set_rss_param().

Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after subchannels open")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/rndis_filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1165,6 +1165,9 @@ int rndis_set_subchannel(struct net_devi
 	wait_event(nvdev->subchan_open,
 		   atomic_read(&nvdev->open_chn) == nvdev->num_chn);
 
+	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
+		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
+
 	/* ignore failures from setting rss parameters, still have channels */
 	if (dev_info)
 		rndis_filter_set_rss_param(rdev, dev_info->rss_key);
@@ -1174,9 +1177,6 @@ int rndis_set_subchannel(struct net_devi
 	netif_set_real_num_tx_queues(ndev, nvdev->num_chn);
 	netif_set_real_num_rx_queues(ndev, nvdev->num_chn);
 
-	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
-		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
-
 	return 0;
 }
 



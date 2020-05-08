Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9EA1CAC00
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgEHMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgEHMsu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49979206D6;
        Fri,  8 May 2020 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942130;
        bh=XE+FZXrzBDXXV9ixm2RSI3Bo3Ms8g3nmCf3qjbCYnIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2S/AcPFbUvcOQdLaJjON3H8eD7RgmgrH5wz2LW4ptj18zDz5hWGkUwuqCZSPCznBG
         zdLo1ds18o3GX0bsdp89t0L8q1ZDmVakR3+tx+SesL3ISkQe7zOBeEQMuacFzNf/iE
         0ZtcbGrC3ZzPd9thRBJCFPUZRsESzn1e2taoa324=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 308/312] net: ep93xx_eth: Do not crash unloading module
Date:   Fri,  8 May 2020 14:34:59 +0200
Message-Id: <20200508123146.174409141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit c823abac17926767fb50175e098f087a6ac684c3 upstream.

When we unload the ep93xx_eth, whether we have opened the network
interface or not, we will either hit a kernel paging request error, or a
simple NULL pointer de-reference because:

- if ep93xx_open has been called, we have created a valid DMA mapping
  for ep->descs, when we call ep93xx_stop, we also call
  ep93xx_free_buffers, ep->descs now has a stale value

- if ep93xx_open has not been called, we have a NULL pointer for
  ep->descs, so performing any operation against that address just won't
  work

Fix this by adding a NULL pointer check for ep->descs which means that
ep93xx_free_buffers() was able to successfully tear down the descriptors
and free the DMA cookie as well.

Fixes: 1d22e05df818 ("[PATCH] Cirrus Logic ep93xx ethernet driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/cirrus/ep93xx_eth.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/cirrus/ep93xx_eth.c
+++ b/drivers/net/ethernet/cirrus/ep93xx_eth.c
@@ -468,6 +468,9 @@ static void ep93xx_free_buffers(struct e
 	struct device *dev = ep->dev->dev.parent;
 	int i;
 
+	if (!ep->descs)
+		return;
+
 	for (i = 0; i < RX_QUEUE_ENTRIES; i++) {
 		dma_addr_t d;
 
@@ -490,6 +493,7 @@ static void ep93xx_free_buffers(struct e
 
 	dma_free_coherent(dev, sizeof(struct ep93xx_descs), ep->descs,
 							ep->descs_dma_addr);
+	ep->descs = NULL;
 }
 
 static int ep93xx_alloc_buffers(struct ep93xx_priv *ep)



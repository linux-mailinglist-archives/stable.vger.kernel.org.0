Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4479187F76
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCQLBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgCQLBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:01:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89ACA20719;
        Tue, 17 Mar 2020 11:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442896;
        bh=Tbj5WL8SPue0E0E5qaSWqOOfcrvNZoS5dH/MKj6Acno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGnSavYnjBqaSGYrGis7wI4xZu7BGfya64rj+PxwBtbjy97HzljxzOatEWirz5nwH
         SvMF+i/kTNRpFneEHqeqFim1Yqunyh3Gxs+U+sSXuAIq8KkJ3y0HV/+7hNogP7OnOr
         rRM3v4zK1uiXZPsYItqqO75Nc+TX78whBGftJAXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Shute <Derek.Shute@stratus.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 027/123] sfc: detach from cb_page in efx_copy_channel()
Date:   Tue, 17 Mar 2020 11:54:14 +0100
Message-Id: <20200317103310.587197342@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 4b1bd9db078f7d5332c8601a2f5bd43cf0458fd4 ]

It's a resource, not a parameter, so we can't copy it into the new
 channel's TX queues, otherwise aliasing will lead to resource-
 management bugs if the channel is subsequently torn down without
 being initialised.

Before the Fixes:-tagged commit there was a similar bug with
 tsoh_page, but I'm not sure it's worth doing another fix for such
 old kernels.

Fixes: e9117e5099ea ("sfc: Firmware-Assisted TSO version 2")
Suggested-by: Derek Shute <Derek.Shute@stratus.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -519,6 +519,7 @@ efx_copy_channel(const struct efx_channe
 		if (tx_queue->channel)
 			tx_queue->channel = channel;
 		tx_queue->buffer = NULL;
+		tx_queue->cb_page = NULL;
 		memset(&tx_queue->txd, 0, sizeof(tx_queue->txd));
 	}
 



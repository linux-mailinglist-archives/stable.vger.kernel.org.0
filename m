Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB46718B4F7
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgCSNO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729295AbgCSNO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5794C206D7;
        Thu, 19 Mar 2020 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623665;
        bh=3J71idgcuS7F1zoVhJFs+RnAKFrKs7xBL1+eUS1nj1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+Qse36g/B2SuGDdm2vqDZip/4gtWGd+1SM91lSKYCN5AW+PYs0NqFTpzKHa47b51
         ko0eKhXzcXQ7sxVEfeHt5g7KxiXnRUEAJek98xu5X+rqYkvlXRPDRrNCi8rsrlVZAG
         lbrU26Bc01/IdZnOHCJDUzV+uCmI+gpQr+uWHgY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Shute <Derek.Shute@stratus.com>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 13/99] sfc: detach from cb_page in efx_copy_channel()
Date:   Thu, 19 Mar 2020 14:02:51 +0100
Message-Id: <20200319123945.560952967@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -505,6 +505,7 @@ efx_copy_channel(const struct efx_channe
 		if (tx_queue->channel)
 			tx_queue->channel = channel;
 		tx_queue->buffer = NULL;
+		tx_queue->cb_page = NULL;
 		memset(&tx_queue->txd, 0, sizeof(tx_queue->txd));
 	}
 



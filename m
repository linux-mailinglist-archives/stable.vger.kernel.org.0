Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3429B7FB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798623AbgJ0P3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798555AbgJ0P2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A86922202;
        Tue, 27 Oct 2020 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812520;
        bh=djeQK07WAzOym9cflaDxntvqZ9F2/pMB0SsJzli+NP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWIgONYTcTgrHfhtlrqzX/276IBvoBLBAggKkFL4lFzgtzfSz5VJMVLk6ebs0uOc/
         xJaHetu5oDYBjGDWWbpT9N9Hd+UKZd5qb9PHzqt3YW9sBTCUhuXUutNsBfbF+SZxGw
         kAU5YTKGqR4Is3aP5Yl8tK23f8gXrYw2+Gb4VhlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 237/757] sfc: dont double-down() filters in ef100_reset()
Date:   Tue, 27 Oct 2020 14:48:07 +0100
Message-Id: <20201027135501.706610738@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 7dcc9d8a40f85cbd76acdebcc45ccdfe4a84337f ]

dev_close(), by way of ef100_net_stop(), already brings down the filter
 table, so there's no need to do it again (which just causes lots of
 WARN_ONs).
Similarly, don't bring it up ourselves, as dev_open() -> ef100_net_open()
 will do it, and will fail if it's already been brought up.

Fixes: a9dc3d5612ce ("sfc_ef100: RX filter table management and related gubbins")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 19fe86b3b3169..9cf5b8f8fab9a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -428,24 +428,12 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 		__clear_bit(reset_type, &efx->reset_pending);
 		rc = dev_open(efx->net_dev, NULL);
 	} else if (reset_type == RESET_TYPE_ALL) {
-		/* A RESET_TYPE_ALL will cause filters to be removed, so we remove filters
-		 * and reprobe after reset to avoid removing filters twice
-		 */
-		down_write(&efx->filter_sem);
-		ef100_filter_table_down(efx);
-		up_write(&efx->filter_sem);
 		rc = efx_mcdi_reset(efx, reset_type);
 		if (rc)
 			return rc;
 
 		netif_device_attach(efx->net_dev);
 
-		down_write(&efx->filter_sem);
-		rc = ef100_filter_table_up(efx);
-		up_write(&efx->filter_sem);
-		if (rc)
-			return rc;
-
 		rc = dev_open(efx->net_dev, NULL);
 	} else {
 		rc = 1;	/* Leave the device closed */
-- 
2.25.1




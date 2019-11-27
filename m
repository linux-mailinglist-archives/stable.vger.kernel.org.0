Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4304210B8BC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfK0UqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbfK0UqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE1E217D6;
        Wed, 27 Nov 2019 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887570;
        bh=lugFMPJ1DzJF5JJ73kFrDkZQ7895HclbYHXx7hxytII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOASrjOCZ0pyRdyl0CMSiGxXpMCB5G22FqoBEH85JbXefzCVfpS41Jww1WLwYEIT8
         jbWamz/7pHhvoUGayMoAfwO67oX6GfHx8Y++VLAG+uIdCVOzrt70C+HQdbRWlgJheF
         VMKqhPBURw1baGAlN9yjOCAVzmuhvIQHSe7mftw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 003/211] sfc: Only cancel the PPS workqueue if it exists
Date:   Wed, 27 Nov 2019 21:28:56 +0100
Message-Id: <20191127203049.791674783@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Habets <mhabets@solarflare.com>

[ Upstream commit 723eb53690041740a13ac78efeaf6804f5d684c9 ]

The workqueue only exists for the primary PF. For other functions
we hit a WARN_ON in kernel/workqueue.c.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ptp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1320,7 +1320,8 @@ void efx_ptp_remove(struct efx_nic *efx)
 	(void)efx_ptp_disable(efx);
 
 	cancel_work_sync(&efx->ptp_data->work);
-	cancel_work_sync(&efx->ptp_data->pps_work);
+	if (efx->ptp_data->pps_workwq)
+		cancel_work_sync(&efx->ptp_data->pps_work);
 
 	skb_queue_purge(&efx->ptp_data->rxq);
 	skb_queue_purge(&efx->ptp_data->txq);



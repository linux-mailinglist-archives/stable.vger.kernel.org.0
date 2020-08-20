Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6346624BA47
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgHTMEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:04:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgHTJ7N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42A722CAE;
        Thu, 20 Aug 2020 09:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917553;
        bh=q+/BfhKioI3638M7k9ipVudVd623gBSf1KwRlG9SoYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wW0u6OS/Gwhl+CpiVi/tVLuQwWW866pIw4O+WrK4VNn0MKiLsyQzPEuOVxYO3r237
         IHewlBd1PJjQYAVXl/lbamvLYnF0ASnk0IpdOk1yC19/gAsoCnRZXvbR90b3XqYnx9
         2A9UhslJanWGm503RFsZUs6WUUuhbybfmTX1zzrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/212] ibmvnic: Fix IRQ mapping disposal in error path
Date:   Thu, 20 Aug 2020 11:20:05 +0200
Message-Id: <20200820091603.982157277@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 27a2145d6f826d1fad9de06ac541b1016ced3427 ]

RX queue IRQ mappings are disposed in both the TX IRQ and RX IRQ
error paths. Fix this and dispose of TX IRQ mappings correctly in
case of an error.

Fixes: ea22d51a7831 ("ibmvnic: simplify and improve driver probe function")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 20f7ab4aa2f15..d25b76440c114 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1515,7 +1515,7 @@ req_rx_irq_failed:
 req_tx_irq_failed:
 	for (j = 0; j < i; j++) {
 		free_irq(adapter->tx_scrq[j]->irq, adapter->tx_scrq[j]);
-		irq_dispose_mapping(adapter->rx_scrq[j]->irq);
+		irq_dispose_mapping(adapter->tx_scrq[j]->irq);
 	}
 	release_sub_crqs_no_irqs(adapter);
 	return rc;
-- 
2.25.1




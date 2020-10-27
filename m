Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80CD29B9A9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802689AbgJ0Pux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802354AbgJ0PqW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C7E21D42;
        Tue, 27 Oct 2020 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813582;
        bh=fiPxW/hHS4W0olmhI36Fiy6gwSxjpfh6zYxlbyd2moo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yrm+uNJz9+BInEm5UqRhTEhxsOpR1j/DDdmRDR7T3uKAAkZsQegwth547R72G6b8K
         ledszL7RSum3DUvDJ4EL3M8P5v905NT2NYe1dXjTBfeO4/OwZyyqQ5N7fMuYx+0Zxu
         IgNN0PKHlXT7IkcXel4ljVhmfrvjJ9cvDfqQO0E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 600/757] dmaengine: ti: k3-udma-glue: Fix parameters for rx ring pair request
Date:   Tue, 27 Oct 2020 14:54:10 +0100
Message-Id: <20201027135518.689269252@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 6259c8441c4de3f1727a0db61465a8dc8f340c05 ]

The original commit mixed up the forward and completion ring IDs for the
rx flow configuration.

Acked-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Fixes: 4927b1ab2047 ("dmaengine: ti: k3-udma: Switch to k3_ringacc_request_rings_pair")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index 42c8ad10d75eb..a367584f0d7b3 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -573,8 +573,8 @@ static int k3_udma_glue_cfg_rx_flow(struct k3_udma_glue_rx_channel *rx_chn,
 
 	/* request and cfg rings */
 	ret =  k3_ringacc_request_rings_pair(rx_chn->common.ringacc,
-					     flow_cfg->ring_rxq_id,
 					     flow_cfg->ring_rxfdq0_id,
+					     flow_cfg->ring_rxq_id,
 					     &flow->ringrxfdq,
 					     &flow->ringrx);
 	if (ret) {
-- 
2.25.1




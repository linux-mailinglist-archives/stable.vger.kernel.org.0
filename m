Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E13395F0A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhEaOG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233444AbhEaOE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B801561451;
        Mon, 31 May 2021 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468296;
        bh=FjffVfX7ZHBpMoEV5UGia/iEkAw5C7P7xXuBqUhqT+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VURsmjU66kViCnDMJXAmo5FUajxsYLarQ0aLtXSA75hsNE343ExCCkBvG7+e+HLHJ
         XVfseScrGn9ddIhVZJkhStAfntDuQ2GULEumH3ya4ndSji72y6By9HCgU2erPyld9j
         5VqYR41DMdkok/nX55w38admAE5HB473xhTgpuIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sinan Kaya <okaya@kernel.org>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/252] dmaengine: qcom_hidma: comment platform_driver_register call
Date:   Mon, 31 May 2021 15:13:40 +0200
Message-Id: <20210531130703.273282204@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 4df2a8b0ad634d98a67e540a4e18a60f943e7d9f ]

Place a comment in hidma_mgmt_init explaining why success must
currently be assumed, due to the cleanup issue that would need to
be considered were this module ever to be unloadable or were this
platform_driver_register call ever to fail.

Acked-By: Vinod Koul <vkoul@kernel.org>
Acked-By: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-52-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/hidma_mgmt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c
index fe87b01f7a4e..62026607f3f8 100644
--- a/drivers/dma/qcom/hidma_mgmt.c
+++ b/drivers/dma/qcom/hidma_mgmt.c
@@ -418,6 +418,20 @@ static int __init hidma_mgmt_init(void)
 		hidma_mgmt_of_populate_channels(child);
 	}
 #endif
+	/*
+	 * We do not check for return value here, as it is assumed that
+	 * platform_driver_register must not fail. The reason for this is that
+	 * the (potential) hidma_mgmt_of_populate_channels calls above are not
+	 * cleaned up if it does fail, and to do this work is quite
+	 * complicated. In particular, various calls of of_address_to_resource,
+	 * of_irq_to_resource, platform_device_register_full, of_dma_configure,
+	 * and of_msi_configure which then call other functions and so on, must
+	 * be cleaned up - this is not a trivial exercise.
+	 *
+	 * Currently, this module is not intended to be unloaded, and there is
+	 * no module_exit function defined which does the needed cleanup. For
+	 * this reason, we have to assume success here.
+	 */
 	platform_driver_register(&hidma_mgmt_driver);
 
 	return 0;
-- 
2.30.2




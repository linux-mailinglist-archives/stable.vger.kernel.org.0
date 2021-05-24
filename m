Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5E38EBAE
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhEXPGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234006AbhEXPCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33B6C6148E;
        Mon, 24 May 2021 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867820;
        bh=VHyJePAyYhLaCiPGvFQJSh66K3zPSB0orscaqg9bJV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZFATz/xIhxTr977B22KXA7UTkjFJf+igrmakq+++JyWvP6tlaXz0umozmbBpVRjI
         TEHCeL7E+KE2f+Gut8byDEZaZwOlHx3VUm9BO70LUIOv70Ezv5CJRR2IOJ2YiL0y2a
         Pt+I2LYvy+yRDMUIeQroLuxCdN1rr6TrPR4M3LGe53UBcI7tvPj8/oc9J9K3Aql7W1
         /Y2Mb65PNJCcKdiSfQJiEvUyFl4s1lS1QlcJQnhZlBwdyL05LOvPkpOdaWL8/kDAPr
         JUFZY8XmrQEYxZBB7oRq7/TmqGjGnRqO8B1czjwPiqm/2w4xLomtG5SkapS9lom80i
         b6ppYQjnTUmbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        Vinod Koul <vkoul@kernel.org>, Sinan Kaya <okaya@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/25] dmaengine: qcom_hidma: comment platform_driver_register call
Date:   Mon, 24 May 2021 10:49:52 -0400
Message-Id: <20210524145008.2499049-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d64edeb6771a..f9640e37b139 100644
--- a/drivers/dma/qcom/hidma_mgmt.c
+++ b/drivers/dma/qcom/hidma_mgmt.c
@@ -423,6 +423,20 @@ static int __init hidma_mgmt_init(void)
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


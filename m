Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62739621E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhEaOvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhEaOtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C00561C91;
        Mon, 31 May 2021 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469402;
        bh=FjffVfX7ZHBpMoEV5UGia/iEkAw5C7P7xXuBqUhqT+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSsEyxHvoUvMkQPsXIAHLk9iLPBc5APH2uZ0LIZBDO3PJiWiUuQMvCJCngjQCrn2F
         doapuqC4rfyZv1UlgN2N3QjX26U2kNz3sFqLd3cbReeYiUoRPGm2ih8JM4LTwg84ry
         CfYzTpDXVQLL2JR325bV24pttOUej43X/XfIu38o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Sinan Kaya <okaya@kernel.org>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 185/296] dmaengine: qcom_hidma: comment platform_driver_register call
Date:   Mon, 31 May 2021 15:14:00 +0200
Message-Id: <20210531130710.085917946@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387A63CA9EB
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbhGOTLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242556AbhGOTH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342BC613D1;
        Thu, 15 Jul 2021 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375843;
        bh=aSoqkgLMMkj0nH15Wv3eicMFw1uKtGpu3lgUv1xvyjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3Xix7tH2kog63oNb2ahEO7JoMwXXRZgtTtMIGpVcUQyFNrqyT1691gyy8+5wnnYi
         2L0CvIst7KP147kGnnIn4P08izcu45QTrllThVGF4CT8CSmhTUDLTRKm7Fq5kjk6ME
         Cu4hc1xizL62q3hxV16Ds2yCf2e+xEvtmtGO1dtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 018/266] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Thu, 15 Jul 2021 20:36:13 +0200
Message-Id: <20210715182617.081781922@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 1c72e6ab66b9598cac741ed397438a52065a8f1f ]

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 933e3ff2ee8d..3f2ebfb06afd 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3279,7 +3279,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.30.2




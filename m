Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2A6353DCF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237445AbhDEJCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237310AbhDEJCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C51CB60238;
        Mon,  5 Apr 2021 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613330;
        bh=JMQqpmH2GVDMDBiZT10RiNv1wdhPPSz452g7VOmohJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnIfCO0suUanBozDtezPnzW6nKj8X9PPSPNI2X7XlvB9hURU1cVB8/vz5UAvITR9C
         iAfDgedqkg8JSp7tfyiR8/yJ0Oot3SKitsJYjdXfcEJGIGA2eJ9yvT4ztkWv9/XKv6
         8PdDc4FWv2rOOM78PWMLROEd1H97NmiTCHRLBuY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 4.19 53/56] usb: dwc2: Fix HPRT0.PrtSusp bit setting for HiKey 960 board.
Date:   Mon,  5 Apr 2021 10:54:24 +0200
Message-Id: <20210405085024.221811393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>

commit 5e3bbae8ee3d677a0aa2919dc62b5c60ea01ba61 upstream.

Increased the waiting timeout for HPRT0.PrtSusp register field
to be set, because on HiKey 960 board HPRT0.PrtSusp wasn't
generated with the existing timeout.

Cc: <stable@vger.kernel.org> # 4.18
Fixes: 22bb5cfdf13a ("usb: dwc2: Fix host exit from hibernation flow.")
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/20210326102447.8F7FEA005D@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5560,7 +5560,7 @@ int dwc2_host_enter_hibernation(struct d
 	dwc2_writel(hsotg, hprt0, HPRT0);
 
 	/* Wait for the HPRT0.PrtSusp register field to be set */
-	if (dwc2_hsotg_wait_bit_set(hsotg, HPRT0, HPRT0_SUSP, 3000))
+	if (dwc2_hsotg_wait_bit_set(hsotg, HPRT0, HPRT0_SUSP, 5000))
 		dev_warn(hsotg->dev, "Suspend wasn't generated\n");
 
 	/*



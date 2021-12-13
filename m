Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E570472926
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhLMKS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhLMKPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EF8C0D942F;
        Mon, 13 Dec 2021 01:55:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE559B80E12;
        Mon, 13 Dec 2021 09:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D41BC3460F;
        Mon, 13 Dec 2021 09:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389321;
        bh=b7XiazldPB1cmYSQDRYAv+VSXuPYEL29JcbWCYbusIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re5Lw7AJHH6SdJi0ilmFGdwaevAxy1tV3FF9qObXSREhhO+wAadO1r0Yk4YJKmO06
         sjbzclGpTt4+d98l28ntr8vN7upVp2s8gB9NwRi++DGnmw/3H+n0JuedRrRkNhwJ0j
         ypOI5dl/Hzqm8ycf4Wo4mPto6aWWS7SukxKggQ6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 026/171] can: m_can: pci: fix incorrect reference clock rate
Date:   Mon, 13 Dec 2021 10:29:01 +0100
Message-Id: <20211213092945.944847983@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit 8c03b8bff765ac4146342ef90931bb50e788c758 upstream.

When testing the CAN controller on our Ekhart Lake hardware, we
determined that all communication was running with twice the configured
bitrate. Changing the reference clock rate from 100MHz to 200MHz fixed
this. Intel's support has confirmed to us that 200MHz is indeed the
correct clock rate.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Link: https://lore.kernel.org/all/c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,7 +18,7 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
-#define M_CAN_CLOCK_FREQ_EHL		100000000
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
 struct m_can_pci_priv {



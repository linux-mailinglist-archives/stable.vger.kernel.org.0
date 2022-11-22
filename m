Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE82633D4C
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 14:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbiKVNOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 08:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiKVNOR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 08:14:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C99E49
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 05:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669122856; x=1700658856;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JLlZ6n2CtogaxyxCu6FwHXjb8OSC6OlSUmDf30+IIQ4=;
  b=G2zqaDmqYsdB9qV/XPwriFa0e3s6eUShvDRk5OtW7aFgrBzX4cbvdvgL
   R0f+zef5StK2a+lZ/XCFjxPeOihGtpWIr0IytTaE60ADa08csCeVGuPmi
   3hCOm0IRKwukMlCHZ4ijZKu1andbw7/VZGGIM/VVWuacZXhpITwolU3RT
   s8UMXFKA44T8kdTrhD2ncOZq0QhKN7hAfWzWoJa7TNhRJVYQmBhagszyH
   J8rzx7Y2C2Bgcfc8uFuO6UjSxmYJyZ6q2EM3eKAaEbK4/VDo1LPyrbm/J
   947m88pLNDPtKkbSAU6EGGkRTcBvAQFG2d+LcCzOtK23TpgWZFsiNvkKm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="314959735"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="314959735"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 05:14:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="643716089"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="643716089"
Received: from mfelter-mobl1.ger.corp.intel.com ([10.249.47.253])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 05:14:13 -0800
Date:   Tue, 22 Nov 2022 15:14:10 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH backport to 4.19 and below 1/1] serial: 8250: Flush DMA
 Rx on RLSI
In-Reply-To: <Y3zDOjgx8LtUMfjj@kroah.com>
Message-ID: <6b75c9c-7ccf-435a-4247-62e2a08a6ea@linux.intel.com>
References: <1b9ac2f-d4a7-1efd-fb6f-c7f8e014ca19@linux.intel.com> <Y3zDOjgx8LtUMfjj@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-581878374-1669122854=:2536"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-581878374-1669122854=:2536
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

commit 1980860e0c8299316cddaf0992dd9e1258ec9d88 upstream.

Returning true from handle_rx_dma() without flushing DMA first creates
a data ordering hazard. If DMA Rx has handled any character at the
point when RLSI occurs, the non-DMA path handles any pending characters
jumping them ahead of those characters that are pending under DMA.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index cab3a74281ef..8aee43fe488a 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1802,10 +1802,9 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 		if (!up->dma->rx_running)
 			break;
 		/* fall-through */
+	case UART_IIR_RLSI:
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
-		/* fall-through */
-	case UART_IIR_RLSI:
 		return true;
 	}
 	return up->dma->rx_dma(up);
-- 
2.30.2

--8323329-581878374-1669122854=:2536--

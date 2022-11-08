Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C1D621041
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiKHMUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiKHMUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:20:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1837C29C84;
        Tue,  8 Nov 2022 04:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667910012; x=1699446012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kwbVN41tr92ZOfdbCaPY/Bzq8aetPvpbAPbc0F2INvo=;
  b=f9dSnV9YmZNy7/bwQhn2sPRCFDfzf6kZQuXy3lST9apAy8PezSQzqFL6
   mSYFJNWd0X+IdGWDsgTls1ny42WciPPo9KuJja9YF9N5ZAxufKzP9n1Ww
   dyh866Q0Epm52aaAf48lEJzvutK/7OU0uzycZ5sqvMB6gboXhbcPIjNPm
   xXW06V4D25QmfbgnpS4/M4eYZ7sd0FXeXMwDFRzoze8mbf3U/9/IAcd8A
   1p/uqG1Hxx4VlQoAoBojpDAZUVAuxt9ffn0phMMWKjJwUfTOMUhyWmxEK
   xFe4v4N8Fj9t4Uwky4KhQdaQ+OGRgbSbkQy0jAITc4DibIkEmFXAUh/ws
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="311834671"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="311834671"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 04:20:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="741932192"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="741932192"
Received: from ppkrause-mobl.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.249.44.73])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 04:20:08 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Gilles BULOZ <gilles.buloz@kontron.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org,
        Srikanth Thokala <srikanth.thokala@intel.com>,
        Aman Kumar <aman.kumar@intel.com>
Subject: [PATCH v2 1/4] serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
Date:   Tue,  8 Nov 2022 14:19:49 +0200
Message-Id: <20221108121952.5497-2-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108121952.5497-1-ilpo.jarvinen@linux.intel.com>
References: <20221108121952.5497-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DW UART sometimes triggers IIR_RDI during DMA Rx when IIR_RX_TIMEOUT
should have been triggered instead. Since IIR_RDI has higher priority
than IIR_RX_TIMEOUT, this causes the Rx to hang into interrupt loop.
The problem seems to occur at least with some combinations of
small-sized transfers (I've reproduced the problem on Elkhart Lake PSE
UARTs).

If there's already an on-going Rx DMA and IIR_RDI triggers, fall
graciously back to non-DMA Rx. That is, behave as if IIR_RX_TIMEOUT had
occurred.

8250_omap already considers IIR_RDI similar to this change so its
nothing unheard of.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Co-developed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Signed-off-by: Srikanth Thokala <srikanth.thokala@intel.com>
Co-developed-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/8250/8250_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index fe8662cd9402..92dd18716169 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1897,6 +1897,10 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
+		fallthrough;
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
 		fallthrough;
-- 
2.30.2


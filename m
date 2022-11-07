Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB5461F171
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKGLHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 06:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKGLHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 06:07:23 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110F918374;
        Mon,  7 Nov 2022 03:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667819243; x=1699355243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kwbVN41tr92ZOfdbCaPY/Bzq8aetPvpbAPbc0F2INvo=;
  b=klRtpQ4bOaQK/8VI5XINYox9qNZZ/XQVh2K8M871OOweASlAInlHhMO2
   nYy4qqh1XRLM9D7M9fZ2BdlPG4BPamrwpn5mgLSPp9Z1g7726EUaiWgql
   U82Am7JIQkC+CyS4w1of2G412nlq9c6SEHC/Se9wvcMy5IzDYL2Fxp7fb
   6UQasb5daX/nqtSaYIb/zrO53/0j1+CWACc6jpziC/R/14Rw/SyLSb3vy
   jtPNh0OQ3DGW8mvFknt2o6dKdyH1315jnhmbVF2pcykXI/NAEwJLMYJf/
   kWuRBIrPLEN0d7UnqE4wlEFrB/F8IjO9KPcRbC8vFmyamfXR20ZlhPcGz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="290773009"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="290773009"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="586932338"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="586932338"
Received: from gschoede-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.46.211])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:19 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org,
        Srikanth Thokala <srikanth.thokala@intel.com>,
        Aman Kumar <aman.kumar@intel.com>
Subject: [PATCH 1/4] serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
Date:   Mon,  7 Nov 2022 13:07:05 +0200
Message-Id: <20221107110708.58223-2-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107110708.58223-1-ilpo.jarvinen@linux.intel.com>
References: <20221107110708.58223-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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


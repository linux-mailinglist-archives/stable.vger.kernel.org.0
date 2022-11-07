Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9B61F178
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiKGLHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 06:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiKGLHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 06:07:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0239618386;
        Mon,  7 Nov 2022 03:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667819253; x=1699355253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GX897nypwCJ78jjUOfdNotVKqeArdhyavQ6h8PsVU8c=;
  b=iBAai1hLFbwA3ysMoxykDt0hyJZiRbCzyzWNyAomHd9iwAdfPIpenazq
   DAJ4xRaUCowz/bCuNKsj+ayqCsQPHwU5eLHsdLPI4J12fu/Cm1tlh0ztK
   QSDAkQgYXb7v9lj6SuDozCuXagovBnDlqEwUPXqpGTcwy4BKcBwD46JEK
   ecZuik8nyNhIB2JLA/og0EDA1NXsDBOLadHV8GEycOEf3eXBscNamUU/k
   08zrALZsJb3jXpCG6dZaXL0JtegYjufovr9mxUvOgeRtxf50Wm5wUR+zx
   /sEK8i7wpdDIzcNZl0u6GumAdST+Qhj6EMcRalvEEz+p3wnkKlR6KJG1J
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="290773043"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="290773043"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="586932381"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="586932381"
Received: from gschoede-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.46.211])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:31 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>
Subject: [PATCH 4/4] serial: 8250: Flush DMA Rx on RLSI
Date:   Mon,  7 Nov 2022 13:07:08 +0200
Message-Id: <20221107110708.58223-5-ilpo.jarvinen@linux.intel.com>
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

Returning true from handle_rx_dma() without flushing DMA first creates
a data ordering hazard. If DMA Rx has handled any character at the
point when RLSI occurs, the non-DMA path handles any pending characters
jumping them ahead of those characters that are pending under DMA.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Cc: Gilles BULOZ <gilles.buloz@kontron.com>

 drivers/tty/serial/8250/8250_port.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 92dd18716169..388172289627 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1901,10 +1901,9 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 		if (!up->dma->rx_running)
 			break;
 		fallthrough;
+	case UART_IIR_RLSI:
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
-		fallthrough;
-	case UART_IIR_RLSI:
 		return true;
 	}
 	return up->dma->rx_dma(up);
-- 
2.30.2


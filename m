Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C68621046
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiKHMUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiKHMUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:20:22 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9905E13F1A;
        Tue,  8 Nov 2022 04:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667910021; x=1699446021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U3IZ849nN3cT/APl5Y2asdOcNM93x6vO1SV0zIv20QY=;
  b=Qax7mrGSGeYBpn/CaFXYJltw4Gg3DtYwjToKeGya+YPxMhmJHacscoXZ
   BPqplRx+rL3FjUxQequuozACbBayotfztyi+zjgCpvkQ6noqF2UQ7XBru
   IAZNjM5Y1s82Q2lD0qsKDMoy0suudY620MVzSi34TPlg4W7uXXehEV9Gc
   v8yOUUZoc9SjtggPOk+URBtnWnZTU1avRoUtMcHkjm5Mh5MK/cezvy2ei
   SiQDNkPmwS+AR+0zsjeXAR1tOFDgzUc+uKRT7quX9ItnNq70/co0h63lb
   h1RJKreLCZsuw5v89xIHyAYAAdWAjTftc1f9J4aW4LIxrVMQ4XZml0leP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="374951461"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="374951461"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 04:20:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="741932222"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="741932222"
Received: from ppkrause-mobl.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.249.44.73])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 04:20:17 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Gilles BULOZ <gilles.buloz@kontron.com>, stable@vger.kernel.org,
        Wentong Wu <wentong.wu@intel.com>
Subject: [PATCH v2 3/4] serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake
Date:   Tue,  8 Nov 2022 14:19:51 +0200
Message-Id: <20221108121952.5497-4-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108121952.5497-1-ilpo.jarvinen@linux.intel.com>
References: <20221108121952.5497-1-ilpo.jarvinen@linux.intel.com>
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

Configure DMA to use 16B burst size with Elkhart Lake. This makes the
bus use more efficient and works around an issue which occurs with the
previously used 1B.

The fix was initially developed by Srikanth Thokala and Aman Kumar.
This together with the previous config change is the cleaned up version
of the original fix.

Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
Reported-by: Wentong Wu <wentong.wu@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/8250/8250_lpss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 7d9cddbfef40..0e43bdfb7459 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -174,6 +174,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	 */
 	up->dma = dma;
 
+	lpss->dma_maxburst = 16;
+
 	port->set_termios = dw8250_do_set_termios;
 
 	return 0;
-- 
2.30.2


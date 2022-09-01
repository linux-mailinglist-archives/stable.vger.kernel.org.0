Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3743F5A9A9E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiIAOkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 10:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiIAOkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 10:40:18 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695742BB33;
        Thu,  1 Sep 2022 07:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662043206; x=1693579206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=esWDLWdVUmofxHacNDJ2TfKXCQbNLSqrTFIBVUEvytQ=;
  b=AWwHUs6XmAs8XyA3YI4lSCzxDlQ+eUJ20cBFBKz4peRxDT32wYS+euKD
   +p/36cVElFCNGlel0dRDf2bsQ1YvIJVRIy3FnVeDmoTfzzSgdCh7Xio1c
   JIAXZBeoc1M1kz9z9ucRg3TNQcW3Gg3MA35nvYfdu2z0+wY43KLGKihAM
   r+mJOEe1LOmXhqx9inIEq1yWZvro3630MUYWWJdDbEneDVEGSl+f4DMLF
   j/1dWi6ynyZAQlLrmPpncq5agUnOr8GTwxaGeahTQ7Nuzkj5RcVLwRCI9
   pFHedv9VTwRGwduKQPxqlkfz8CVylMCBrPop+qb4zzGHDhTiNIuDDRHyb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297014837"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297014837"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:40:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="642356704"
Received: from rmalliu-mobl.amr.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.249.44.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 07:39:57 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v2 RESEND 3/3] serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx accounting
Date:   Thu,  1 Sep 2022 17:39:34 +0300
Message-Id: <20220901143934.8850-4-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220901143934.8850-1-ilpo.jarvinen@linux.intel.com>
References: <20220901143934.8850-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tx'ing does not correctly account Tx'ed characters into icount.tx.
Using uart_xmit_advance() fixes the problem.

Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Fixes: 2d908b38d409 ("serial: Add Tegra Combined UART driver")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/tegra-tcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/tegra-tcu.c b/drivers/tty/serial/tegra-tcu.c
index 4877c54c613d..889b701ba7c6 100644
--- a/drivers/tty/serial/tegra-tcu.c
+++ b/drivers/tty/serial/tegra-tcu.c
@@ -101,7 +101,7 @@ static void tegra_tcu_uart_start_tx(struct uart_port *port)
 			break;
 
 		tegra_tcu_write(tcu, &xmit->buf[xmit->tail], count);
-		xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+		uart_xmit_advance(port, count);
 	}
 
 	uart_write_wakeup(port);
-- 
2.30.2


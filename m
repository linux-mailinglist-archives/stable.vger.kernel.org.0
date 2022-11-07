Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0430261F174
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiKGLHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 06:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiKGLHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 06:07:32 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7256218364;
        Mon,  7 Nov 2022 03:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667819251; x=1699355251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gbTRCkxxLdOZW1y6aGgrb7XRmU8BTA5iNZdcQ5OXGmE=;
  b=TKH12svCttUpMooVWeFxd0W2LsXEOWYvyXaD0JViSkjlGlTvo4q/CgO0
   kLPRU1255lpL/Kiqa7ZtfLvRNtX/yCwjHF5simTlPezMC9hmC25W9QF0h
   z+KDN7btn4j5mZnJ02w7AgftCYk+YJr/RHnhHil78tlUUXbGsOPQoEiOw
   efwkvLeX/se+ZwYSN7HN3TCkGvTHLOpETc2pKmYFHPsnQzuka21YLNHah
   QZiv72y2wEJlAIEJM8Y27as5KA4mQgmeog4/RyiqpVc6yR0hUeqsthT/x
   vZ4B0g57V1tsWq9zHYtGzb6M05z+w8OoIQzX+qxabG/5MJeYP0Q82jVZr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="290773035"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="290773035"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="586932376"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="586932376"
Received: from gschoede-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.46.211])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:07:26 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     stable@vger.kernel.org, Wentong Wu <wentong.wu@intel.com>,
        Srikanth Thokala <srikanth.thokala@intel.com>,
        Aman Kumar <aman.kumar@intel.com>
Subject: [PATCH 3/4] serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake
Date:   Mon,  7 Nov 2022 13:07:07 +0200
Message-Id: <20221107110708.58223-4-ilpo.jarvinen@linux.intel.com>
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

Configure DMA to use 16B burst size with Elkhart Lake. This makes the
bus use more efficient and works around an issue which occurs with the
previously used 1B.

Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
Reported-by: Wentong Wu <wentong.wu@intel.com>
Co-developed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Signed-off-by: Srikanth Thokala <srikanth.thokala@intel.com>
Co-developed-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

---
I know the list of Co-dev-bys & Sob seems a bit odd for a oneliner.
The reason is that I cleaned up this from a more complex patch using
the earlier change that I authored myself so only this oneliner
remained in this patch.
---
 drivers/tty/serial/8250/8250_lpss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index ed281445a97d..e0b4e1446eac 100644
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


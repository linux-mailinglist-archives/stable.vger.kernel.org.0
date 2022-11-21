Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A41632256
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiKUMhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiKUMhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:37:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D72BEC
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669034232; x=1700570232;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-id;
  bh=kyoVWlpE6jnMJfeDf88xAskKFJ1AJbkWl0qX3adVQL8=;
  b=J2XIMz/OpR7GTVT+8G/v1X/7HhzfeY8gNTPAbR3EaNRAjwgvez6Steqo
   zGY3wm2994rGJmnlkdRcWAqtlHbrg0L12clJkGhfM5Yy35jEtp63sTm4p
   c6ZuhQWDG9m7RRJH/aZZXSKMhkcWOB7S77G4RbwUn89ZPr5UBNi7S8xPn
   BGIcDt3B8odkKn1Nyt6hx970/Wj7DLxqnBPyT98hZNVrcoNtGwcd4XWJc
   U0hBVkAZUUDXiatWZOlOlJVv7LzqeCZb44QsGASEPLoBxu71WeKIFAqlv
   yEo9PhpK7C72oYxVOR8Gp+cAoUHRrYUcaXoMNQqqx0ZLMiwigo303W6zG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="314694447"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="314694447"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 04:37:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="673959349"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="673959349"
Received: from ebarboza-mobl1.amr.corp.intel.com ([10.251.209.16])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 04:37:10 -0800
Date:   Mon, 21 Nov 2022 14:37:03 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, wentong.wu@intel.com
Subject: [PATCH backport to 5.15 1/1] serial: 8250_lpss: Use 16B DMA burst
 with Elkhart Lake
Message-ID: <38cd338-61e5-5cbc-d3f6-9dc326f38743@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-6729518-1669034138=:1681"
Content-ID: <759f8cad-ac5f-e5d-4541-c9183866db5e@linux.intel.com>
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

--8323329-6729518-1669034138=:1681
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <5962a1a8-1f82-d6c7-fcdd-d1fe4a72cabf@linux.intel.com>

commit 7090abd6ad0610a144523ce4ffcb8560909bf2a8 upstream.

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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_lpss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 49ae73f4d3a0..078f12f856f6 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -177,6 +177,9 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	 * matching with the registered General Purpose DMA controllers.
 	 */
 	up->dma = dma;
+
+	lpss->dma_maxburst = 16;
+
 	return 0;
 }
 
-- 
2.30.2
--8323329-6729518-1669034138=:1681--

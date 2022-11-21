Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02D6322D3
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKUMtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:49:30 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7444B4830
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669034969; x=1700570969;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=o+8q2/TLGgEqfFQUlj11tERfrp2MKUeGIJvaDMAda0E=;
  b=bsvXd3P9VY6gNrPpf88KDbayjsc5QjCy6xa+aDVie3v82QWBO/Nn64rm
   xGXOUtmXE6irgk+d+RkzveBOYcr7xZbYzHHLxUgMFC7W1q/4yBfPtVQrs
   PvaMLmaJpOt+5vjkxVRQSwdyw8ZctMcJGEiopZmMu+gXwTjXLElakcxKM
   LGsRFLCoYr/zl+POt33hxJhWbbEXWq5JWdfUjCzsZTy3Ri8bwj2Ruto6q
   GNL6pkE3QaZ0tDtEA4u9zqOpechyO+JecxUEk475FjXJMq+IS8KpgRsMz
   bbY7J8mZ/ORkXUil0fnd5zYNHg4eq6zHJumgucontypbzEYBodIHsOdh9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="313577133"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="313577133"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 04:49:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="970062406"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="970062406"
Received: from ebarboza-mobl1.amr.corp.intel.com ([10.251.209.16])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 04:49:28 -0800
Date:   Mon, 21 Nov 2022 14:49:25 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH backport to 5.4 and below 1/1] serial: 8250: Flush DMA Rx on
 RLSI
Message-ID: <1b9ac2f-d4a7-1efd-fb6f-c7f8e014ca19@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-705308838-1669034969=:1681"
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-705308838-1669034969=:1681
Content-Type: text/plain; charset=UTF-8
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
index 97a64bc79350..b47335dfae16 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1824,10 +1824,9 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 		if (!up->dma->rx_running)
 			break;
 		fallthrough;
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

--8323329-705308838-1669034969=:1681--

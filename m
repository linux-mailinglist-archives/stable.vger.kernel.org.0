Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D470D65BD3C
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 10:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbjACJes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 04:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjACJeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 04:34:44 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8D9E3C;
        Tue,  3 Jan 2023 01:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672738483; x=1704274483;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8AGwAjvHJ0btsKD9yaGewvpaJNJi1fzYP5R08FbNXhE=;
  b=Hy7yKxPG/QcoBCZA/qBJXtN0Sc5SS2De5rgyTW9VOEa1IK2tvjMjz4JV
   NdDL0OjdtvwqQswn9wyYuZj4tUnsIBYTBSzfXgnWova/Ib29Uh5xJnOON
   eSUrnCtufUFiqxtoP5d8CbYxIhqAtnnXJgnqr8VimudqGfj3jCSVPCDHJ
   PH95rayWxnMd0ONT+TZpAEeygBzGGb8i4raSifbkSGYtz73qb3/p1BQXt
   Z3vQ/Aq1fGrdJ4OjECwCqV7viSrZjrK7XtXrnoXgmFhhoX3VVPXJHfqJB
   /Dt8FZwb19A7KKfIAZBE1qMpBJcGVLrXHkoWfz8k05lYMA6is6bv3Y1q7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="305128061"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="305128061"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 01:34:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="654721808"
X-IronPort-AV: E=Sophos;i="5.96,296,1665471600"; 
   d="scan'208";a="654721808"
Received: from pdaniel-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.48.214])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 01:34:40 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 1/1] serial: pch_uart: Pass correct sg to dma_unmap_sg()
Date:   Tue,  3 Jan 2023 11:34:35 +0200
Message-Id: <20230103093435.4396-1-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A local variable sg is used to store scatterlist pointer in
pch_dma_tx_complete(). The for loop doing Tx byte accounting before
dma_unmap_sg() alters sg in its increment statement. Therefore, the
pointer passed into dma_unmap_sg() won't match to the one given to
dma_map_sg().

To fix the problem, use priv->sg_tx_p directly in dma_unmap_sg()
instead of the local variable.

Fixes: da3564ee027e ("pch_uart: add multi-scatter processing")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/serial/pch_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 3d54a43768cd..9576ba8bbc40 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -749,7 +749,7 @@ static void pch_dma_tx_complete(void *arg)
 		uart_xmit_advance(port, sg_dma_len(sg));
 
 	async_tx_ack(priv->desc_tx);
-	dma_unmap_sg(port->dev, sg, priv->orig_nent, DMA_TO_DEVICE);
+	dma_unmap_sg(port->dev, priv->sg_tx_p, priv->orig_nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
 	priv->nent = 0;
 	priv->orig_nent = 0;
-- 
2.30.2


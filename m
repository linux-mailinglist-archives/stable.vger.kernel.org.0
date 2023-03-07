Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9A16AF498
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjCGTRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCGTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0663C4884;
        Tue,  7 Mar 2023 11:01:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BA5F61522;
        Tue,  7 Mar 2023 19:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548E3C433EF;
        Tue,  7 Mar 2023 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215667;
        bh=reVceQw8Vjx9DCDFgIspNsUMefaa5uHVjxDU6awyz2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGmT13anfTY8J7ztslV1AcWL3hN6Dn2LRdQ0oUdpWld1ylpkZv5kOoFHU39A5kVxI
         CltbV57/aaGCBF3iC4KtMAf2NOBC63IhCAxtvPi/+S5K2uYkP+Z2zbQ2WgMBNLIU3h
         XqZnSMLxUBE2VwpNGp/kx1+hlSQBPdMwAnMimeo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/567] dmaengine: dw-axi-dmac: Do not dereference NULL structure
Date:   Tue,  7 Mar 2023 18:01:12 +0100
Message-Id: <20230307165920.444892107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit be4d46edeee4b2459d2f53f37ada88bbfb634b6c ]

If "vdesc" is NULL, it cannot be used with vd_to_axi_desc(). Leave
"bytes" unchanged at 0. Seen under GCC 13 with -Warray-bounds:

../drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c: In function 'dma_chan_tx_status':
../drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c:329:46: warning: array subscript 0 is outside array bounds of 'struct
virt_dma_desc[46116860184273879]' [-Warray-bounds=]
  329 |                 bytes = vd_to_axi_desc(vdesc)->length;
      |                                              ^~

Fixes: 8e55444da65c ("dmaengine: dw-axi-dmac: Support burst residue granularity")
Cc: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230127223623.never.507-kees@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 41654b2f6c600..cfc47efcb5d93 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -288,8 +288,6 @@ dma_chan_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 		len = vd_to_axi_desc(vdesc)->hw_desc[0].len;
 		completed_length = completed_blocks * len;
 		bytes = length - completed_length;
-	} else {
-		bytes = vd_to_axi_desc(vdesc)->length;
 	}
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
-- 
2.39.2




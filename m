Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A3F6AF054
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCGSaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbjCGS30 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0C6AA241;
        Tue,  7 Mar 2023 10:22:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4C261501;
        Tue,  7 Mar 2023 18:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EC4C4339B;
        Tue,  7 Mar 2023 18:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213365;
        bh=X5Kev56y7YGnAKASzygP7QcKaEky7kIxHJKVW2nbC40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBlDCavI3A6VAhvkheEQNTHbMHasZKouo4AlPxEfW849NFFIK2PCpZZDzqwrEC06p
         4r8JYy2Ys5bYx95BzYAJdiMum5GJtrifPDDqkZaLoSPJ0GtE+cGDWh8aqF+mBywH+a
         8mIRRrNU0ztuoqqE/XcLWJ/xOPSffgmpXmf+WldE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 485/885] dmaengine: dw-axi-dmac: Do not dereference NULL structure
Date:   Tue,  7 Mar 2023 17:56:59 +0100
Message-Id: <20230307170023.538433020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index bf85aa0979ecb..152c5d98524d7 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -325,8 +325,6 @@ dma_chan_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 		len = vd_to_axi_desc(vdesc)->hw_desc[0].len;
 		completed_length = completed_blocks * len;
 		bytes = length - completed_length;
-	} else {
-		bytes = vd_to_axi_desc(vdesc)->length;
 	}
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
-- 
2.39.2




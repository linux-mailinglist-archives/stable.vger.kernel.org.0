Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B841556F9CF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiGKJJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiGKJIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:08:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61E4275C0;
        Mon, 11 Jul 2022 02:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD4BF6118F;
        Mon, 11 Jul 2022 09:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C612CC341CD;
        Mon, 11 Jul 2022 09:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530471;
        bh=CJBE30fgZXe3monlOPi4HZcMFV3BbSj4yu2McIeje50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clJTqzAUaBixZgu1sUEE8eXG+1d+cekYuk43qjFLmrxYESosYE7ZeZ0RFb43MfGIJ
         wcTKN9cgaW3CsM8Lv9uVUhkIrLeu3/aYpyj1iTlIP9qW5ws6strNgtjlyZ/mDmFUhB
         QPvtpV/6xMAhlnbUTjA9cfXs2dgMlS1DlsONNAy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 16/17] dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate
Date:   Mon, 11 Jul 2022 11:06:41 +0200
Message-Id: <20220711090536.747481497@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit c132fe78ad7b4ce8b5d49a501a15c29d08eeb23a upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not needed anymore.

Add missing of_node_put() in to fix this.

Fixes: ec9bfa1e1a79 ("dmaengine: ti-dma-crossbar: dra7: Use bitops instead of idr")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220605042723.17668-2-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti-dma-crossbar.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/ti-dma-crossbar.c
+++ b/drivers/dma/ti-dma-crossbar.c
@@ -274,6 +274,7 @@ static void *ti_dra7_xbar_route_allocate
 		mutex_unlock(&xbar->mutex);
 		dev_err(&pdev->dev, "Run out of free DMA requests\n");
 		kfree(map);
+		of_node_put(dma_spec->np);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(map->xbar_out, xbar->dma_inuse);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6A755DE4F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbiF0L2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiF0L1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:27:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774D59585;
        Mon, 27 Jun 2022 04:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15050614C8;
        Mon, 27 Jun 2022 11:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A84C3411D;
        Mon, 27 Jun 2022 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329223;
        bh=OOi6JiC4hHGgym1taXsN4xlgN6UDOKMGxg2GFNAwFLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nxrw6CsK40Yn8mXyFdv3Bf4rU1tlT53r5JGW/R3nkyo6IgtGGaV/ulohMa/zK90sw
         lOJjoAavZSZO4cOCFU5Ni/igCYdUCxGBvGMySTdG6sK6xB7vNlGWZ861fBVpms7hhX
         tRQG7qsQ/nForlQIJk06WDkBdS971UHwQdFJw1RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 084/102] iio: adc: adi-axi-adc: Fix refcount leak in adi_axi_adc_attach_client
Date:   Mon, 27 Jun 2022 13:21:35 +0200
Message-Id: <20220627111935.958757066@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit ada7b0c0dedafd7d059115adf49e48acba3153a8 upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: ef04070692a2 ("iio: adc: adi-axi-adc: add support for AXI ADC IP core")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220524074517.45268-1-linmq006@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -334,16 +334,19 @@ static struct adi_axi_adc_client *adi_ax
 
 		if (!try_module_get(cl->dev->driver->owner)) {
 			mutex_unlock(&registered_clients_lock);
+			of_node_put(cln);
 			return ERR_PTR(-ENODEV);
 		}
 
 		get_device(cl->dev);
 		cl->info = info;
 		mutex_unlock(&registered_clients_lock);
+		of_node_put(cln);
 		return cl;
 	}
 
 	mutex_unlock(&registered_clients_lock);
+	of_node_put(cln);
 
 	return ERR_PTR(-EPROBE_DEFER);
 }



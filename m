Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B8356F9CC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiGKJJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGKJIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:08:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5952022B26;
        Mon, 11 Jul 2022 02:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2BA6B80E7B;
        Mon, 11 Jul 2022 09:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12064C34115;
        Mon, 11 Jul 2022 09:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530468;
        bh=8tFdo+OIIS3mTEzo0rS2Tz8lJWzmLaRAn8Rg1nhuTjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MFfU6I7TkLRps5DBMJBzDrL2zd/YSZCbzmNN9XkxOV5ZaafPfYHssmzjgL3EN3C8
         noWM7VG+Nna9j0LDrDqnnFgwWyBXWdNg40ZEJfegtiaM5qF/vcuHpmrnrQqeJgCQiw
         S20xk5CgdCzG6asEGbLeQfm+ngezBkQVQ2ju2ez8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 15/17] dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly
Date:   Mon, 11 Jul 2022 11:06:40 +0200
Message-Id: <20220711090536.717217005@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

commit 3770d92bd5237d686e49da7b2fb86f53ee6ed259 upstream.

It seems that it is valid to have less than the requested number of
descriptors. But what is not valid and leads to subsequent errors is to
have zero descriptors. In that case, abort the probing.

Fixes: e1f7c9eee707 ("dmaengine: at_xdmac: creation of the atmel eXtended DMA Controller driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20220526135111.1470926-1-michael@walle.cc
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1804,6 +1804,11 @@ static int at_xdmac_alloc_chan_resources
 	for (i = 0; i < init_nr_desc_per_channel; i++) {
 		desc = at_xdmac_alloc_desc(chan, GFP_ATOMIC);
 		if (!desc) {
+			if (i == 0) {
+				dev_warn(chan2dev(chan),
+					 "can't allocate any descriptors\n");
+				return -EIO;
+			}
 			dev_warn(chan2dev(chan),
 				"only %d descriptors have been allocated\n", i);
 			break;



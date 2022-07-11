Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5834556FBEF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiGKJhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiGKJgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:36:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EDD820DC;
        Mon, 11 Jul 2022 02:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23414B80E76;
        Mon, 11 Jul 2022 09:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72203C34115;
        Mon, 11 Jul 2022 09:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531136;
        bh=XBONTpeGMl4Fkew44k0xDUFHUV3pxi3H65zw282K6WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm8a9f6D2An+1PqeNyB/bjUHJ8cqXWjBK9J84Khyx2ckJSDQbOInN+7XLXVWwbXSS
         17zUYlpi21K7lDUUvC7jDR2Hw5nue6HivkVPGkyK06lXtbjAi6y51uuGvMj1tjLGgb
         QZroowmlSmT93v+CywVtMS1rHr1htgDYl+fyICJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 108/112] dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly
Date:   Mon, 11 Jul 2022 11:07:48 +0200
Message-Id: <20220711090552.635437033@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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
@@ -1893,6 +1893,11 @@ static int at_xdmac_alloc_chan_resources
 	for (i = 0; i < init_nr_desc_per_channel; i++) {
 		desc = at_xdmac_alloc_desc(chan, GFP_KERNEL);
 		if (!desc) {
+			if (i == 0) {
+				dev_warn(chan2dev(chan),
+					 "can't allocate any descriptors\n");
+				return -EIO;
+			}
 			dev_warn(chan2dev(chan),
 				"only %d descriptors have been allocated\n", i);
 			break;



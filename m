Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E24F24F0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbiDEHnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiDEHmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:42:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55F92D0A;
        Tue,  5 Apr 2022 00:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0051B81B9C;
        Tue,  5 Apr 2022 07:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F185EC36AF6;
        Tue,  5 Apr 2022 07:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144409;
        bh=nnTFLW16oIblOmfe/dj9vSHeypEbnAa+4PcXi2kkabY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTDVRjn3SFjrE+N2vBYPlv50cHQfMfIoTbaerYhkhZH35G1KYs86kHBT1P0k9Em17
         ZtAQbIOBxoHUOYdQO4EYoSYKAJoU9Wfna/AWmfdxWWRA9RBOKu/pLpqI7RUm115JXR
         voj15jC2UThu6n96un45DFnmZCZVT1nrsS3tAV8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michael Tretter <m.tretter@pengutronix.de>,
        Michal Simek <michal.simek@xilinx.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 0034/1126] iio: adc: xilinx-ams: Fixed missing PS channels
Date:   Tue,  5 Apr 2022 09:13:01 +0200
Message-Id: <20220405070408.556854294@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 1f21a41578062d439cc485bce2d8b664f9a6170e upstream.

The code forgot to increment num_channels for the PS channel inputs,
resulting in them not being enabled as they should.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-3-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1230,6 +1230,7 @@ static int ams_init_module(struct iio_de
 
 		/* add PS channels to iio device channels */
 		memcpy(channels, ams_ps_channels, sizeof(ams_ps_channels));
+		num_channels = ARRAY_SIZE(ams_ps_channels);
 	} else if (fwnode_property_match_string(fwnode, "compatible",
 						"xlnx,zynqmp-ams-pl") == 0) {
 		ams->pl_base = fwnode_iomap(fwnode, 0);



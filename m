Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79F468D817
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjBGNFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjBGNFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:05:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E3F3A58F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:05:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8489BCE1CA5
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A744C4339B;
        Tue,  7 Feb 2023 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775094;
        bh=sP9NFXg/tlRbb+P7nepIMIFKhcsu2YgWBrOPUaw2VAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CudZhk0jW6rI/c/d/zV6aG14zcK2WHvmYr6/aJ58jhrXKf0web96YJyRZXpoRzMfe
         Wwubdu4tFl1S97AvroXjbycpc/+8Idr0ZCjNyBFw+liBZEZab7sjzJIClP5lIK9tXP
         f3r2tiMEVI0ODGUluYptf045igiCWLjoSOH6W4LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Pagani <marpagan@redhat.com>,
        Michal Simek <michal.simek@amd.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 134/208] iio: adc: xilinx-ams: fix devm_krealloc() return value check
Date:   Tue,  7 Feb 2023 13:56:28 +0100
Message-Id: <20230207125640.500768222@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Pagani <marpagan@redhat.com>

commit 6794ed0cfcc6ce737240eccc48b3e8190df36703 upstream.

The clang-analyzer reported a warning: "Value stored to 'ret'
is never read".

Fix the return value check if devm_krealloc() fails to resize
ams_channels.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221125113112.219290-1-marpagan@redhat.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-ams.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -1329,7 +1329,7 @@ static int ams_parse_firmware(struct iio
 
 	dev_channels = devm_krealloc(dev, ams_channels, dev_size, GFP_KERNEL);
 	if (!dev_channels)
-		ret = -ENOMEM;
+		return -ENOMEM;
 
 	indio_dev->channels = dev_channels;
 	indio_dev->num_channels = num_channels;



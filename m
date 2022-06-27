Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858F055C1DF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbiF0Lxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238922AbiF0Lwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57462DF22;
        Mon, 27 Jun 2022 04:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E91A3B80D37;
        Mon, 27 Jun 2022 11:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C86C3411D;
        Mon, 27 Jun 2022 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330387;
        bh=SxpGI+CQk3fn6M8/MgNMGVqxpD3nKniUZv1qZm4HGwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY7uRXaEps9mOa4O0Gwi+kNrzkoNXynOUYhKr5DcOvV8w8JGfHJGOeRcQc4NvNBUZ
         Aqzj1CALBJtMW71GmzBMnAZUNi7UwmVFbyMYGxqUIYP4cmMcNDZWQ2bF672yqQyG3L
         iZI0ju83birm18lPptqiz02Ipk6kgez/YO7tCnGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aashish Sharma <shraash@google.com>,
        kernel test robot <lkp@intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.18 131/181] iio:proximity:sx9324: Check ret value of device_property_read_u32_array()
Date:   Mon, 27 Jun 2022 13:21:44 +0200
Message-Id: <20220627111948.489224737@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

From: Aashish Sharma <shraash@google.com>

commit 70171ed6dc53d2f580166d47f5b66cf51a6d0092 upstream.

0-day reports:

drivers/iio/proximity/sx9324.c:868:3: warning: Value stored
to 'ret' is never read [clang-analyzer-deadcode.DeadStores]

Put an if condition to break out of switch if ret is non-zero.

Signed-off-by: Aashish Sharma <shraash@google.com>
Fixes: a8ee3b32f5da ("iio:proximity:sx9324: Add dt_binding support")
Reported-by: kernel test robot <lkp@intel.com>
[swboyd@chromium.org: Reword commit subject, add fixes tag]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20220613232224.2466278-1-swboyd@chromium.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9324.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -885,6 +885,9 @@ sx9324_get_default_reg(struct device *de
 			break;
 		ret = device_property_read_u32_array(dev, prop, pin_defs,
 						     ARRAY_SIZE(pin_defs));
+		if (ret)
+			break;
+
 		for (pin = 0; pin < SX9324_NUM_PINS; pin++)
 			raw |= (pin_defs[pin] << (2 * pin)) &
 			       SX9324_REG_AFE_PH0_PIN_MASK(pin);



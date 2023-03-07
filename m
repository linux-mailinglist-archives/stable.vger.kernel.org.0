Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E936AF032
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbjCGS30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCGS3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7688ADC36
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:21:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B3961530
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85579C433EF;
        Tue,  7 Mar 2023 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213304;
        bh=7lKrqRekoS5bnka07Cs1M1ZpVdVJxOWi7mXE/YIW9Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KB3sQXXNajk8IoN2Ee6GNPYBBooVXcc+F2nWASRcxFwZDmjZqPHmHrxVG5vZlZF1
         QHOYPJweNWMvhaES7BoApeatBuf8S85CohTsFCB2VjAIl+Y90KqwAWIixHppMiQybg
         lRcX+9WFiazvuncCckSAsTdUzoitzvG6z19o+IvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/885] usb: max-3421: Fix setting of I/O pins
Date:   Tue,  7 Mar 2023 17:56:38 +0100
Message-Id: <20230307170022.669751285@linuxfoundation.org>
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

From: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>

[ Upstream commit a7efe3fc7cbe27c6eb2c2a3ab612194f8f800f4c ]

To update the I/O pins, the registers are read/modified/written. The
read operation incorrectly always read the first register. Although
wrong, there wasn't any impact as all the output pins are always
written, and the inputs are read only anyway.

Fixes: 2d53139f3162 ("Add support for using a MAX3421E chip as a host driver.")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20230207033337.18112-1-mark.tomlinson@alliedtelesis.co.nz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 352e3ac2b377b..19111e83ac131 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1436,7 +1436,7 @@ max3421_spi_thread(void *dev_id)
 			 * use spi_wr_buf().
 			 */
 			for (i = 0; i < ARRAY_SIZE(max3421_hcd->iopins); ++i) {
-				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1);
+				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1 + i);
 
 				val = ((val & 0xf0) |
 				       (max3421_hcd->iopins[i] & 0x0f));
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB2350563E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242490AbiDRNcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244842AbiDRNa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839EA1EC5A;
        Mon, 18 Apr 2022 05:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D11AB80E44;
        Mon, 18 Apr 2022 12:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E4FC385A7;
        Mon, 18 Apr 2022 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286556;
        bh=Q3w88jQapsjel3TT3enbcYkshX+XJytx1WvOuZLFhqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTltroFgxzxObv2iyP0l/7wbqDEh1A/Vm2X7JrUb1NQrEAGqsZQlr14gAbQD2b0t7
         c0b36fO1YsWOMkIQ8r7KmA30qaWYCX0R6qYMIT117FyeJ0nf9CI7vbiaRlRXioxsu0
         ZM14vXsQ237JUX4b5Eu5o2kbnNozAXEVKywkqLiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 131/284] staging:iio:adc:ad7280a: Fix handing of device address bit reversing.
Date:   Mon, 18 Apr 2022 14:11:52 +0200
Message-Id: <20220418121215.031561694@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f281e4ddbbc0b60f061bc18a2834e9363ba85f9f ]

The bit reversal was wrong for bits 1 and 3 of the 5 bits.
Result is driver failure to probe if you have more than 2 daisy-chained
devices.  Discovered via QEMU based device emulation.

Fixes tag is for when this moved from a macro to a function, but it
was broken before that.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 065a7c0b1fec ("Staging: iio: adc: ad7280a.c: Fixed Macro argument reuse")
Reviewed-by: Marcelo Schmitt <marcelo.schmitt1@gmail.com>
Link: https://lore.kernel.org/r/20220206190328.333093-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7280a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index f17f700ea04f..0b639da562d9 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -102,9 +102,9 @@
 static unsigned int ad7280a_devaddr(unsigned int addr)
 {
 	return ((addr & 0x1) << 4) |
-	       ((addr & 0x2) << 3) |
+	       ((addr & 0x2) << 2) |
 	       (addr & 0x4) |
-	       ((addr & 0x8) >> 3) |
+	       ((addr & 0x8) >> 2) |
 	       ((addr & 0x10) >> 4);
 }
 
-- 
2.34.1




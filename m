Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B8521791
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244036AbiEJN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243092AbiEJNZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431BF185C8F;
        Tue, 10 May 2022 06:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D12D961574;
        Tue, 10 May 2022 13:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DBBC385C2;
        Tue, 10 May 2022 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188732;
        bh=sXILfzq9IW3DCNFKyH1tGuQNRkOLW85EMG6ylDqHGXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VNr79mSkRRMylbvytpex57m+NHNLxfm+0l3NuFuKAioEQgGmoqEAQ0XALBElJAQJ
         MCQkrWmWqgBQ2QXkx3Kqr97jNQwlpNVFX55UT5qj2S4glkMUyYGaL1p7mJ7W28vhN2
         6UpSULqyqfbU+hHW3z2xQpCSO2X6b7M0kG0kS53s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 09/88] iio: dac: ad5592r: Fix the missing return value.
Date:   Tue, 10 May 2022 15:06:54 +0200
Message-Id: <20220510130734.015700859@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zizhuang Deng <sunsetdzz@gmail.com>

commit b55b38f7cc12da3b9ef36e7a3b7f8f96737df4d5 upstream.

The third call to `fwnode_property_read_u32` did not record
the return value, resulting in `channel_offstate` possibly
being assigned the wrong value.

Fixes: 56ca9db862bf ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Signed-off-by: Zizhuang Deng <sunsetdzz@gmail.com>
Link: https://lore.kernel.org/r/20220310125450.4164164-1-sunsetdzz@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5592r-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -531,7 +531,7 @@ static int ad5592r_alloc_channels(struct
 		if (!ret)
 			st->channel_modes[reg] = tmp;
 
-		fwnode_property_read_u32(child, "adi,off-state", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,off-state", &tmp);
 		if (!ret)
 			st->channel_offstate[reg] = tmp;
 	}



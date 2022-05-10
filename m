Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D957552167A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbiEJNOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242259AbiEJNOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:14:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BC0DE8F;
        Tue, 10 May 2022 06:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BAF1B81DA0;
        Tue, 10 May 2022 13:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ABC385A6;
        Tue, 10 May 2022 13:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188249;
        bh=ycpbxAto+dh1Mn2Va8iL5uowbHR53RqJ38c0L1VvIxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URNxyDP+XrT2qf7w6hqOjkc0oKQH381Bq91RZsxjIa96c0SOmYCE9w2dXs8c8nPyd
         FQa2hD0CwQ+2EyvD91jNkbq9hyGJfZRlbfbEAgqdNoJP07JT4Q6BHPrTbVyq9i4wli
         SylvSzf57ueBog5+wkDmrGm1PecFADvLtjA4+ZS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 11/66] iio: dac: ad5592r: Fix the missing return value.
Date:   Tue, 10 May 2022 15:07:01 +0200
Message-Id: <20220510130730.100058610@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
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
@@ -532,7 +532,7 @@ static int ad5592r_alloc_channels(struct
 		if (!ret)
 			st->channel_modes[reg] = tmp;
 
-		fwnode_property_read_u32(child, "adi,off-state", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,off-state", &tmp);
 		if (!ret)
 			st->channel_offstate[reg] = tmp;
 	}



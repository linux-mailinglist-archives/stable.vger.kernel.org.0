Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479D951A620
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353737AbiEDQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353685AbiEDQwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF2473B2;
        Wed,  4 May 2022 09:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F3B7B82752;
        Wed,  4 May 2022 16:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF68C385A4;
        Wed,  4 May 2022 16:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682918;
        bh=bWIjm8It5BNOSRlnHwW+zxNkTiw7XIoQ7LfvoH41GnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuykhxRtSebG/qCWzKonwqQZq2RcqYNRnjlXKFs418qPlc/SqgBTnG5gfzH9DIuSX
         VRtceGhd1r1Og/+nO6rZ6760Efm6ii0JZ01mVi16Qzd5kB9lvTS+ymWF8DBZag4oDY
         OFo162xnfDj/hK+qd3HXZ78Rl0W2KpnZbfBsZTqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zizhuang Deng <sunsetdzz@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 14/84] iio: dac: ad5592r: Fix the missing return value.
Date:   Wed,  4 May 2022 18:43:55 +0200
Message-Id: <20220504152928.826085238@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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
@@ -530,7 +530,7 @@ static int ad5592r_alloc_channels(struct
 		if (!ret)
 			st->channel_modes[reg] = tmp;
 
-		fwnode_property_read_u32(child, "adi,off-state", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,off-state", &tmp);
 		if (!ret)
 			st->channel_offstate[reg] = tmp;
 	}



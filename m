Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A399651A5FE
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353665AbiEDQwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353681AbiEDQwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E964704A;
        Wed,  4 May 2022 09:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73925B8279A;
        Wed,  4 May 2022 16:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AA8C385A4;
        Wed,  4 May 2022 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682905;
        bh=N2OJ8A9Pgd4tQdz72XK9NSdvVzRl/vedp+YId9WKg1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFAUuEcw3LJZOdkr3ANpq6retuuOpciCoEh6gy2e5Mkbt8DZWZIr+x+w503HAGI1m
         MCKUookecHV4y4QpjkPklM52pDL7OEkll0aaFB5ERskXWw3JQknIwugCnUh9OKXjBa
         a5u6tzCc1kV7oOWiLfiIfJKmJF7uLi+E7Qw7vA3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 15/84] iio: dac: ad5446: Fix read_raw not returning set value
Date:   Wed,  4 May 2022 18:43:56 +0200
Message-Id: <20220504152928.881800756@linuxfoundation.org>
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

From: Michael Hennerich <michael.hennerich@analog.com>

commit 89a01cd688d3c0ac983ef0b0e5f40018ab768317 upstream.

read_raw should return the un-scaled value.

Fixes: 5e06bdfb46e8b ("staging:iio:dac:ad5446: Return cached value for 'raw' attribute")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220406105620.1171340-1-michael.hennerich@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5446.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -170,7 +170,7 @@ static int ad5446_read_raw(struct iio_de
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
-		*val = st->cached_val;
+		*val = st->cached_val >> chan->scan_type.shift;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		*val = st->vref_mv;



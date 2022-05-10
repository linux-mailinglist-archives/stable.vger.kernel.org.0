Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA92521752
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242995AbiEJNXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242998AbiEJNVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45704A3F5;
        Tue, 10 May 2022 06:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13176B81DA4;
        Tue, 10 May 2022 13:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A85FC385A6;
        Tue, 10 May 2022 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188461;
        bh=LlaNvZNC6zMQ2YYn7Jimy2RhtIUwN/GT9NAOZ5adIg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLBXaf098KUuKqUdlAg3sj4m1Q5Oe2nWSHanxnVSOPc98UxW1ELg86PSj0eLW2HR3
         R0sK18Dsc/A3k3HheaQOsavBPxjsjPQYCtHN+UNiGUpWGcNgZzhG/JSSTrfbzXR0ys
         GSIIR30i+1fF8phHjkf7xzGHZi3zY9JluqUqjW8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 16/78] iio: dac: ad5446: Fix read_raw not returning set value
Date:   Tue, 10 May 2022 15:07:02 +0200
Message-Id: <20220510130733.013232254@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
@@ -171,7 +171,7 @@ static int ad5446_read_raw(struct iio_de
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
-		*val = st->cached_val;
+		*val = st->cached_val >> chan->scan_type.shift;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		*val = st->vref_mv;



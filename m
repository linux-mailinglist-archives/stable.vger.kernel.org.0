Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF78F608AB4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbiJVJE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbiJVJD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5CA2DCB04;
        Sat, 22 Oct 2022 01:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C7B5B82E34;
        Sat, 22 Oct 2022 07:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4101C433B5;
        Sat, 22 Oct 2022 07:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425057;
        bh=daM7vcIsZKr7FdXlFX6dxhQkjn98nSSipw3bhrJuVxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRCqyv67aQ03PR72dCVeTty/NZ03j+KtBl/f18TPgIOt66njwzbrI05VuliRFNk2a
         y/1yLVv+D4vwDPrtOou8RC9hrqHXmndplhzOou+OSslN9r6pkdSFSeGfYKernQ475U
         L7+py7Z/t5Z0g6AtRfCj1QsAa32hbpIcATmLQLYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 376/717] iio: inkern: fix return value in devm_of_iio_channel_get_by_name()
Date:   Sat, 22 Oct 2022 09:24:15 +0200
Message-Id: <20221022072513.816258648@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 9e878dbc0e8322f8b2f5ab0093c1e89926362dbe ]

of_iio_channel_get_by_name() can either return NULL or an error pointer
so that only doing IS_ERR() is not enough. Fix it by checking the NULL
pointer case and return -ENODEV in that case. Note this is done like this
so that users of the function (which only check for error pointers) do
not need to be changed. This is not ideal since we are losing error codes
and as such, in a follow up change, things will be unified so that
of_iio_channel_get_by_name() only returns error codes.

Fixes: 6e39b145cef7 ("iio: provide of_iio_channel_get_by_name() and devm_ version it")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220715122903.332535-3-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 9d87057794fc..87fd2a0d44f2 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -412,6 +412,8 @@ struct iio_channel *devm_of_iio_channel_get_by_name(struct device *dev,
 	channel = of_iio_channel_get_by_name(np, channel_name);
 	if (IS_ERR(channel))
 		return channel;
+	if (!channel)
+		return ERR_PTR(-ENODEV);
 
 	ret = devm_add_action_or_reset(dev, devm_iio_channel_free, channel);
 	if (ret)
-- 
2.35.1




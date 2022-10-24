Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73F60AC08
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJXOB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiJXOBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:01:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E317F270;
        Mon, 24 Oct 2022 05:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BD936129B;
        Mon, 24 Oct 2022 12:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71708C433D7;
        Mon, 24 Oct 2022 12:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615562;
        bh=fpux3ZK3HL0FnpPPjW6CZnlPOsWtzyFLlyQgkydJFcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SReCqQ96dM9yDN13MqG6eE6rmNy5urR2sHbe3pniWHaL5VN7igZWvQO2GG2eBmaE7
         eOCsUoXhEG22Lq+tHgCMDYWQo6BA2aXJ2oAoQGH0qu/gEQ8IV/W8tgW0XYQUJu6vAt
         ddOIyJ4T6jaSlapb6+Z1hB79+wfUrWM02sv0iTS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/530] iio: inkern: fix return value in devm_of_iio_channel_get_by_name()
Date:   Mon, 24 Oct 2022 13:30:13 +0200
Message-Id: <20221024113057.241089465@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 30a8ecb692f8..bf9ce01c854b 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -395,6 +395,8 @@ struct iio_channel *devm_of_iio_channel_get_by_name(struct device *dev,
 	channel = of_iio_channel_get_by_name(np, channel_name);
 	if (IS_ERR(channel))
 		return channel;
+	if (!channel)
+		return ERR_PTR(-ENODEV);
 
 	ret = devm_add_action_or_reset(dev, devm_iio_channel_free, channel);
 	if (ret)
-- 
2.35.1




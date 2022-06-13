Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAAF5491B4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiFMMzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356273AbiFMMx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:53:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4E234BA3;
        Mon, 13 Jun 2022 04:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0BA8BCE1184;
        Mon, 13 Jun 2022 11:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E9C34114;
        Mon, 13 Jun 2022 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118760;
        bh=tJJEMIGLZL6cqJZhjXlWvUQVh2JZbWd6zS2yVjr98bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y1vfdJdjexHCIg0Lx3LHdXHeLHTNCvtV4suMeBMbXdJ56MlvuICvYE1s7uLN/cKe
         n2+9tGlkTbSZPT7o7KSeCyJoUTpYAVZ0sWFCXqxCcJ3NSbajBmzWZq16E1fNEY62uH
         A6tRkrh8DX85ZFu9q2UsYDvuVbH1XEo4qQPfQhkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/247] iio: adc: ad7124: Remove shift from scan_type
Date:   Mon, 13 Jun 2022 12:08:25 +0200
Message-Id: <20220613094922.991177704@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

[ Upstream commit fe78ccf79b0e29fd6d8dc2e2c3b0dbeda4ce3ad8 ]

The 24 bits data is stored in 32 bits in BE. There
is no need to shift it. This confuses user-space apps.

Fixes: b3af341bbd966 ("iio: adc: Add ad7124 support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Link: https://lore.kernel.org/r/20220322105029.86389-2-alexandru.tachici@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 18c154afbd7a..101f2da2811b 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -188,7 +188,6 @@ static const struct iio_chan_spec ad7124_channel_template = {
 		.sign = 'u',
 		.realbits = 24,
 		.storagebits = 32,
-		.shift = 8,
 		.endianness = IIO_BE,
 	},
 };
-- 
2.35.1




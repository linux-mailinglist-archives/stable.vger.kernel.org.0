Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1E65AE9B5
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbiIFNda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240517AbiIFNc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:32:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B8677E92;
        Tue,  6 Sep 2022 06:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70DD7B81636;
        Tue,  6 Sep 2022 13:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC014C433D6;
        Tue,  6 Sep 2022 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471162;
        bh=wqHPCUBxx7Rg50w87XTOL2OcwHMiKLPe+qwpIghfDmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1REMIIakHORyUhNfjTN1zmoxsh3TgcZszyzLyiqLvyp6Q1s+zRiPr1gRWv8SdazkT
         Ek/0iLw5h9TJ8zFBujBEkKImJj7Fj+hI4MOiDyOY6/d7xCvjruFprah6zOLJBLVNiD
         OMcZpmU1evWFzlpWxfNW417r7wX1wvnpmRaxBcZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/80] iio: adc: mcp3911: make use of the sign bit
Date:   Tue,  6 Sep 2022 15:30:03 +0200
Message-Id: <20220906132817.200137615@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 8f89e33bf040bbef66386c426198622180233178 ]

The device supports negative values as well.

Fixes: 3a89b289df5d ("iio: adc: add support for mcp3911")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220722130726.7627-2-marcus.folkesson@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3911.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index e573da5397bb3..81eeb00842112 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -111,6 +111,8 @@ static int mcp3911_read_raw(struct iio_dev *indio_dev,
 		if (ret)
 			goto out;
 
+		*val = sign_extend32(*val, 23);
+
 		ret = IIO_VAL_INT;
 		break;
 
-- 
2.35.1




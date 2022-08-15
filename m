Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DDB5941C8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348589AbiHOVgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348909AbiHOVgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2B92AE07;
        Mon, 15 Aug 2022 12:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AB6460693;
        Mon, 15 Aug 2022 19:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2F6C433D6;
        Mon, 15 Aug 2022 19:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591526;
        bh=b6g+upfMBir4x9nL9lFu0jJvrq9WrlcAMfMMZBcT7hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVJiPiFh6mJV4WQeO0FCTlnSI6dTx0TM8SL0wNbe1GN6MMkuw6Ua7tWZGsZJ+xA3w
         IXfVhsFyY5Of1aBIrww/mv9HsyoQmRwOObCXm1/hJ9RlBU8V8fobV0rQO6i//2WrYt
         U3fw5/U49XRC83b8a8a8i4A4pbsqdnf4V+Otc9sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0607/1095] iio: adc: max1027: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:00:06 +0200
Message-Id: <20220815180454.636359074@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit e754fb7e7a05e3838c9aa044b4114869dd0d1e17 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition.

Fixes: fc167f624833 ("iio: add support of the max1027")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-24-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1027.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
index 4daf1d576c4e..b725d012625c 100644
--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -272,7 +272,7 @@ struct max1027_state {
 	struct mutex			lock;
 	struct completion		complete;
 
-	u8				reg ____cacheline_aligned;
+	u8				reg __aligned(IIO_DMA_MINALIGN);
 };
 
 static int max1027_wait_eoc(struct iio_dev *indio_dev)
-- 
2.35.1




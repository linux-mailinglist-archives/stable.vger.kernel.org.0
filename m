Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C971594A9A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352174AbiHPAFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357256AbiHPAEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:04:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA4E16F8B4;
        Mon, 15 Aug 2022 13:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD30461072;
        Mon, 15 Aug 2022 20:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F44C433C1;
        Mon, 15 Aug 2022 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595295;
        bh=JDPkLbfh5nyLlgAFXZPDXbHbeiCTZRuj1QDiLvOJTDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnpSXsIn7SSVciQa9JytophKTceWF8M4Ox0PZHHLdX+82pWw5IEtNvOzymA0YGiyt
         zI1JNbsHK6VXSZmhYlfO+8C8WfgSfLy9UuM3yCQ4CKf6julo4dhnyy6Azppa0BbqUW
         UKI07jKFXObJwLGOsPOTLvTHtMe02xzPWrwfJLyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Navin Sankar Velliangiri <navin@linumiz.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0718/1157] iio: temp: max31865: Fix alignment for DMA safety
Date:   Mon, 15 Aug 2022 20:01:14 +0200
Message-Id: <20220815180508.222759186@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit ecdef5b8317cdf18acb46223e087f04a226fa619 ]

____cacheline_aligned is an insufficient guarantee for non-coherent DMA
on platforms with 128 byte cachelines above L1.  Switch to the updated
IIO_DMA_MINALIGN definition

Fixes: e112dc4e18ea ("iio: temperature: Add MAX31865 RTD Support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Navin Sankar Velliangiri <navin@linumiz.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20220508175712.647246-92-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/max31865.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/temperature/max31865.c b/drivers/iio/temperature/max31865.c
index e3bb78184c6e..29e23652ba5a 100644
--- a/drivers/iio/temperature/max31865.c
+++ b/drivers/iio/temperature/max31865.c
@@ -55,7 +55,7 @@ struct max31865_data {
 	struct mutex lock;
 	bool filter_50hz;
 	bool three_wire;
-	u8 buf[2] ____cacheline_aligned;
+	u8 buf[2] __aligned(IIO_DMA_MINALIGN);
 };
 
 static int max31865_read(struct max31865_data *data, u8 reg,
-- 
2.35.1




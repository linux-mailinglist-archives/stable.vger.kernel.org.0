Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907AB6DEE42
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjDLIlO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjDLIkX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DB1E65
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF8B6302F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAB4C433EF;
        Wed, 12 Apr 2023 08:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288731;
        bh=FQS306GDYfd638mZ9jZ7/P8HzcxEzggpFUj6t28B4c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgQ9KNK/nnZT+1/e5XR3TevIcHqg+XYaPN9Kq5EZ6mm6HPFFJPKE422bJ+PmeTmL8
         tXVq/kloHoWZT/PDUMcJq0xAY208EPa5VD9j6nRTCFuu0R+MpJ7K5IjCMzKwVB+LHu
         a/bv9ku+UiCn5GDjNjyCte3NBOuion45h0DDCqyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 59/93] iio: adis16480: select CONFIG_CRC32
Date:   Wed, 12 Apr 2023 10:34:00 +0200
Message-Id: <20230412082825.622174714@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit d9b540ee461cca7edca0dd2c2a42625c6b9ffb8f upstream.

In rare randconfig builds, the missing CRC32 helper causes
a link error:

ld.lld: error: undefined symbol: crc32_le
>>> referenced by usercopy_64.c
>>>               vmlinux.o:(adis16480_trigger_handler)

Fixes: 941f130881fa ("iio: adis16480: support burst read function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230131094616.130238-1-arnd@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/Kconfig b/drivers/iio/imu/Kconfig
index f1d7d4b5e222..c2f97629e9cd 100644
--- a/drivers/iio/imu/Kconfig
+++ b/drivers/iio/imu/Kconfig
@@ -47,6 +47,7 @@ config ADIS16480
 	depends on SPI
 	select IIO_ADIS_LIB
 	select IIO_ADIS_LIB_BUFFER if IIO_BUFFER
+	select CRC32
 	help
 	  Say yes here to build support for Analog Devices ADIS16375, ADIS16480,
 	  ADIS16485, ADIS16488 inertial sensors.
-- 
2.40.0




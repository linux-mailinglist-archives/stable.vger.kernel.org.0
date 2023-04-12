Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526996DEF65
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjDLIub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbjDLIuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C9B9023
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3910862B5B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A709C433D2;
        Wed, 12 Apr 2023 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289365;
        bh=/M7FauTKNI/uieWKNJQK7SCkeaUc92i/wKAtMeba600=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOCYpZSlEJ9n1gDoetJZw4bcZ2UgMDj4WhqXvzsb2NdnaaWynBIhOeWp3YH7WjMVI
         xsgYPrgFuJorlKfNoHA/9T34DaBdkbzxONqj39MpWH0VB7EKoxFxcOU2vsXLn6ZETT
         px3NqZEZSelIYsb4EM4lOXBcMMVbSD+83u3EN1XE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 072/173] iio: adis16480: select CONFIG_CRC32
Date:   Wed, 12 Apr 2023 10:33:18 +0200
Message-Id: <20230412082840.956882757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
 drivers/iio/imu/Kconfig |    1 +
 1 file changed, 1 insertion(+)

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



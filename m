Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AC56CBDBF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjC1LcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjC1Lbz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:31:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1839D7A8A
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CCA616D5
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D491C433EF;
        Tue, 28 Mar 2023 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003093;
        bh=tZWtYLkug1majkcQDxJST7xwQtT6C1Ey9k8hNLzbk/g=;
        h=Subject:To:From:Date:From;
        b=etB6R/Jfso8a3Gr20BiwbQF/hk8cD9aHdalGKKpAVsTk+n06Y9icujh6HVBaFjAyL
         dFfI1MGyMyyRjNoFyc8gP0WvO0FaZMoRzCy7eIimJ7WieiMoPMcbIO4LaGCaq1/tp+
         6gizz9Qy2/yeiVqAPijJG4jgNvkOYh3NeUNIOSDM=
Subject: patch "iio: adis16480: select CONFIG_CRC32" added to char-misc-linus
To:     arnd@arndb.de, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:25 +0200
Message-ID: <1680003085171153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16480: select CONFIG_CRC32

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d9b540ee461cca7edca0dd2c2a42625c6b9ffb8f Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 31 Jan 2023 10:46:11 +0100
Subject: iio: adis16480: select CONFIG_CRC32
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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



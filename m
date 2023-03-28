Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF86CBDC4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjC1LcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjC1LcG (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8711BC8
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 15F7CCE1C58
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E98EC433EF;
        Tue, 28 Mar 2023 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003110;
        bh=f2JE5ipp0o2YYWzMg59ve3Jls/pAEf0eCqycILUPlWY=;
        h=Subject:To:From:Date:From;
        b=1+t61SRdvKDoUG1NOm4C9P/iFXJ0PVG/zsF/G+AfoEyyWIj+lHWCvrMV53ASzBOtE
         RNWyIQEMofB4surfB90W0OoDhNRRj0Y8/d9UEXH4sYz50jamNi72vJh5UOuWkJ2x+Z
         6uN8BflOGo1kxLmVJZEzVzAhes9YgGpEU5osaYrw=
Subject: patch "iio: light: cm32181: Unregister second I2C client if present" added to char-misc-linus
To:     kai.heng.feng@canonical.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hdegoede@redhat.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:29 +0200
Message-ID: <168000308961154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: cm32181: Unregister second I2C client if present

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 099cc90a5a62e68b2fe3a42da011ab929b98bf73 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Thu, 23 Feb 2023 10:00:59 +0800
Subject: iio: light: cm32181: Unregister second I2C client if present

If a second dummy client that talks to the actual I2C address was
created in probe(), there should be a proper cleanup on driver and
device removal to avoid leakage.

So unregister the dummy client via another callback.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Fixes: c1e62062ff54 ("iio: light: cm32181: Handle CM3218 ACPI devices with 2 I2C resources")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2152281
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20230223020059.2013993-1-kai.heng.feng@canonical.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/cm32181.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iio/light/cm32181.c b/drivers/iio/light/cm32181.c
index b1674a5bfa36..d4a34a3bf00d 100644
--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -429,6 +429,14 @@ static const struct iio_info cm32181_info = {
 	.attrs			= &cm32181_attribute_group,
 };
 
+static void cm32181_unregister_dummy_client(void *data)
+{
+	struct i2c_client *client = data;
+
+	/* Unregister the dummy client */
+	i2c_unregister_device(client);
+}
+
 static int cm32181_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -460,6 +468,10 @@ static int cm32181_probe(struct i2c_client *client)
 		client = i2c_acpi_new_device(dev, 1, &board_info);
 		if (IS_ERR(client))
 			return PTR_ERR(client);
+
+		ret = devm_add_action_or_reset(dev, cm32181_unregister_dummy_client, client);
+		if (ret)
+			return ret;
 	}
 
 	cm32181 = iio_priv(indio_dev);
-- 
2.40.0



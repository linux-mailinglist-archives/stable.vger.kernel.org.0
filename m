Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBE1521A12
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244520AbiEJNx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244886AbiEJNrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3161B7901;
        Tue, 10 May 2022 06:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE675B81DA0;
        Tue, 10 May 2022 13:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D36C385A6;
        Tue, 10 May 2022 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189542;
        bh=i8n7JjW6cfCdxN4ywe85b4MBmku8Dba+zS2qUV3MPcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/dRISKuEirKs4py2pGyd62R7mjT/getRvAw3SYzOcQjkKQV32gv1b//LJll7Lzd0
         xOBYDDSJDV5eVv/cPufe7KTaV5sHFY/GZJcEgwjhkq1h7i5O/Cgy4PuBUaoMgfz08C
         HhGaYDfHBecYBBYE/auBoY9o/s6974GMDmz7iCxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Wujek <dev_public@wujek.eu>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 043/135] hwmon: (pmbus) disable PEC if not enabled
Date:   Tue, 10 May 2022 15:07:05 +0200
Message-Id: <20220510130741.634904397@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Wujek <dev_public@wujek.eu>

commit 75d2b2b06bd8407d03a3f126bc8b95eb356906c7 upstream.

Explicitly disable PEC when the client does not support it.
The problematic scenario is the following. A device with enabled PEC
support is up and running and a kernel driver is loaded.
Then the driver is unloaded (or device unbound), the HW device
is reconfigured externally (e.g. by i2cset) to advertise itself as not
supporting PEC. Without a new code, at the second load of the driver
(or bind) the "flags" variable is not updated to avoid PEC usage. As a
consequence the further communication with the device is done with
the PEC enabled, which is wrong and may fail.

The implementation first disable the I2C_CLIENT_PEC flag, then the old
code enable it if needed.

Fixes: 4e5418f787ec ("hwmon: (pmbus_core) Check adapter PEC support")
Signed-off-by: Adam Wujek <dev_public@wujek.eu>
Link: https://lore.kernel.org/r/20220420145059.431061-1-dev_public@wujek.eu
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index b2618b1d529e..d93574d6a1fb 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2326,6 +2326,9 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 		data->has_status_word = true;
 	}
 
+	/* Make sure PEC is disabled, will be enabled later if needed */
+	client->flags &= ~I2C_CLIENT_PEC;
+
 	/* Enable PEC if the controller and bus supports it */
 	if (!(data->flags & PMBUS_NO_CAPABILITY)) {
 		ret = i2c_smbus_read_byte_data(client, PMBUS_CAPABILITY);
-- 
2.36.1




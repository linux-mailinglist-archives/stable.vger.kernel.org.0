Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136AB561C50
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbiF3Nwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiF3NwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:52:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4802E69F;
        Thu, 30 Jun 2022 06:49:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0737162007;
        Thu, 30 Jun 2022 13:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF9FC34115;
        Thu, 30 Jun 2022 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596975;
        bh=59dgnchq3XHklAwf0vy/8xadvWw5GpNCkcKvtAD1piM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMAxlE6cguIeJlC07r9AhcCkn0wPVHjKFOvFBO/gRyt+vBJ9t68ulV9bmfl+QfSdi
         PPzi5qV6cWTxdvBj+tgG1R1IjrJqg5sXPYiz9KBu0+N5AfbCzTkLMS/TeACX4FJVX6
         I2jMhzbimKMZv/Ga+rFFsaBhESoB3cSQahI+9HDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 19/35] iio: adc: axp288: Override TS pin bias current for some models
Date:   Thu, 30 Jun 2022 15:46:30 +0200
Message-Id: <20220630133233.006090452@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
References: <20220630133232.433955678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 048058399f19d43cf21de9f5d36cd8144337d004 upstream.

Since commit 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling") we
preserve the bias current set by the firmware at boot. This fixes issues
we were seeing on various models.

Some models like the Nuvision Solo 10 Draw tablet actually need the
old hardcoded 80ųA bias current for battery temperature monitoring
to work properly.

Add a quirk entry for the Nuvision Solo 10 Draw to the DMI quirk table
to restore setting the bias current to 80ųA on this model.

Fixes: 9bcf15f75cac ("iio: adc: axp288: Fix TS-pin handling")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215882
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220506095040.21008-1-hdegoede@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp288_adc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/axp288_adc.c
+++ b/drivers/iio/adc/axp288_adc.c
@@ -213,6 +213,14 @@ static const struct dmi_system_id axp288
 		},
 		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
 	},
+	{
+		/* Nuvision Solo 10 Draw */
+		.matches = {
+		  DMI_MATCH(DMI_SYS_VENDOR, "TMAX"),
+		  DMI_MATCH(DMI_PRODUCT_NAME, "TM101W610L"),
+		},
+		.driver_data = (void *)(uintptr_t)AXP288_ADC_TS_BIAS_80UA,
+	},
 	{}
 };
 



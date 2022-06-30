Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF063561C8B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiF3N74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbiF3N6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E9241999;
        Thu, 30 Jun 2022 06:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A122620FB;
        Thu, 30 Jun 2022 13:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCEC34115;
        Thu, 30 Jun 2022 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597105;
        bh=Urwb/RjVq/tYoyuIqbJgp4bogvrF3sTNzc506eyjWfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIRykTfGKdUoVzn+qcu2K+mJtRvmFBc5DIpjTcnlKCkinLzKbswKqxrdZ1EaB2QcG
         jjt0yfjU3IN/bvFur9nI3kTClZJMbVN5PDDrdzQ12zgtlfu3qPGbTp4W2WVIKwYQhc
         AzP3a0fyHLYOHYRxm6g45LQkMkFrLZOvYmody9W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 29/49] iio: adc: axp288: Override TS pin bias current for some models
Date:   Thu, 30 Jun 2022 15:46:42 +0200
Message-Id: <20220630133234.753206225@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -205,6 +205,14 @@ static const struct dmi_system_id axp288
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
 



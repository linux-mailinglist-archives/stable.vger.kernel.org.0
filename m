Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B9C6D489A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjDCOaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbjDCOaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE60319AC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B74C761DC8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB41C433D2;
        Mon,  3 Apr 2023 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532203;
        bh=hTO5rCFm8m80YtrBSZ/A5k+OnAYqmr6iNzrQePeUj4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gauPnkH1gyCCwwJlLVgDNuD2wSWQn50MeqkWRoJpcAQjp8tMCQY1bKUoQV8wQX7H2
         tJPQTCfJFGuJWjnFkMwRC4GP3drOEyqOhe70TMx7kFHP+dsHaAU2Xc7rnC3rt5DzqV
         Zb/rPfVY9UdeceDDHDehLyFRVraw5RkKCMbfIIDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 149/173] Input: goodix - add Lenovo Yoga Book X90F to nine_bytes_report DMI table
Date:   Mon,  3 Apr 2023 16:09:24 +0200
Message-Id: <20230403140419.271741604@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

commit 8a0432bab6ea3203d220785da7ab3c7677f70ecb upstream.

The Android Lenovo Yoga Book X90F / X90L uses the same goodix touchscreen
with 9 bytes touch reports for its touch keyboard as the already supported
Windows Lenovo Yoga Book X91F/L, add a DMI match for this to
the nine_bytes_report DMI table.

When the quirk for the X91F/L was initially added it was written to
also apply to the X90F/L but this does not work because the Android
version of the Yoga Book uses completely different DMI strings.
Also adjust the X91F/L quirk to reflect that it only applies to
the X91F/L models.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20230315134442.71787-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -183,10 +183,18 @@ static const unsigned long goodix_irq_fl
 static const struct dmi_system_id nine_bytes_report[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
-		.ident = "Lenovo YogaBook",
-		/* YB1-X91L/F and YB1-X90L/F */
+		/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9")
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		}
+	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		}
 	},
 #endif



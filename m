Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60D0635792
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbiKWJng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbiKWJmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:42:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C083610AD27
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCCD61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C546C433C1;
        Wed, 23 Nov 2022 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196422;
        bh=GBvxC92X5aZMOeIL3/LdoqGdqXcHCSF6AmwTzSf1DqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/Zz9SvZVwlAawB1hZ7vyrN2awI1Y2YTgLY68FbJgisaFhFU7cfe/0fD6WiJ7tNu3
         QY5YQ1ZUE1I+cktBQ2OU2OXqXHDOTPc030YJA7S3Ynt9ebdjiegdqCEYx959/IVR0J
         qrczvySUPDD/3MRIV8YErY6uQl/8OUVDIy7i9Gjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jelle van der Waa <jvanderwaa@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 026/314] platform/x86: thinkpad_acpi: Fix reporting a non present second fan on some models
Date:   Wed, 23 Nov 2022 09:47:51 +0100
Message-Id: <20221123084626.685018340@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jelle van der Waa <jvanderwaa@redhat.com>

[ Upstream commit a10d50983f7befe85acf95ea7dbf6ba9187c2d70 ]

thinkpad_acpi was reporting 2 fans on a ThinkPad T14s gen 1, even though
the laptop has only 1 fan.

The second, not present fan always reads 65535 (-1 in 16 bit signed),
ignore fans which report 65535 to avoid reporting the non present fan.

Signed-off-by: Jelle van der Waa <jvanderwaa@redhat.com>
Link: https://lore.kernel.org/r/20221019194751.5392-1-jvanderwaa@redhat.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2dbb9fc011a7..353507d18e11 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -263,6 +263,8 @@ enum tpacpi_hkey_event_t {
 #define TPACPI_DBG_BRGHT	0x0020
 #define TPACPI_DBG_MIXER	0x0040
 
+#define FAN_NOT_PRESENT		65535
+
 #define strlencmp(a, b) (strncmp((a), (b), strlen(b)))
 
 
@@ -8876,7 +8878,7 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			/* Try and probe the 2nd fan */
 			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
-			if (res >= 0) {
+			if (res >= 0 && speed != FAN_NOT_PRESENT) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
-- 
2.35.1




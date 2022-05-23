Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D47531CA4
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241328AbiEWRnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbiEWRhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4095D650;
        Mon, 23 May 2022 10:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E6761245;
        Mon, 23 May 2022 17:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013AC385AA;
        Mon, 23 May 2022 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327053;
        bh=ylNL2KoBbgg1rlNKg/jmvhK/PANiXZGeYbNkevaViIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXbY7+Ps4rPWsVhgj7VPGmOwoUqtqCmVvF5Dkn7RxQ+NuiF4RNZU2LoUluPd4oGLv
         udzDu4ZlW2sHcWASHugfhGFzFsDUD+2GnXSUORTuoMQYCFe4yaE3Bn1xpmNHSSw6pm
         ymgK4zdScvYIkfv9pIZ8y+XHXSlxAR2LZOzM8sso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 142/158] platform/x86: thinkpad_acpi: Correct dual fan probe
Date:   Mon, 23 May 2022 19:04:59 +0200
Message-Id: <20220523165853.830772851@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit aa2fef6f40e6ccc22e932b36898f260f0e5a021a ]

There was an issue with the dual fan probe whereby the probe was
failing as it assuming that second_fan support was not available.

Corrected the logic so the probe works correctly. Cleaned up so
quirks only used if 2nd fan not detected.

Tested on X1 Carbon 10 (2 fans), X1 Carbon 9 (2 fans) and T490 (1 fan)

Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20220502191200.63470-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index c43586f1cb4b..0ea71416d292 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8766,24 +8766,27 @@ static int __init fan_init(struct ibm_init_struct *iibm)
 			fan_status_access_mode = TPACPI_FAN_RD_TPEC;
 			if (quirks & TPACPI_FAN_Q1)
 				fan_quirk1_setup();
-			if (quirks & TPACPI_FAN_2FAN) {
-				tp_features.second_fan = 1;
-				pr_info("secondary fan support enabled\n");
-			}
-			if (quirks & TPACPI_FAN_2CTL) {
-				tp_features.second_fan = 1;
-				tp_features.second_fan_ctl = 1;
-				pr_info("secondary fan control enabled\n");
-			}
 			/* Try and probe the 2nd fan */
+			tp_features.second_fan = 1; /* needed for get_speed to work */
 			res = fan2_get_speed(&speed);
 			if (res >= 0) {
 				/* It responded - so let's assume it's there */
 				tp_features.second_fan = 1;
 				tp_features.second_fan_ctl = 1;
 				pr_info("secondary fan control detected & enabled\n");
+			} else {
+				/* Fan not auto-detected */
+				tp_features.second_fan = 0;
+				if (quirks & TPACPI_FAN_2FAN) {
+					tp_features.second_fan = 1;
+					pr_info("secondary fan support enabled\n");
+				}
+				if (quirks & TPACPI_FAN_2CTL) {
+					tp_features.second_fan = 1;
+					tp_features.second_fan_ctl = 1;
+					pr_info("secondary fan control enabled\n");
+				}
 			}
-
 		} else {
 			pr_err("ThinkPad ACPI EC access misbehaving, fan status and control unavailable\n");
 			return -ENODEV;
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D623E6D95B6
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbjDFLgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237725AbjDFLfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFBAD3A;
        Thu,  6 Apr 2023 04:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C8696447F;
        Thu,  6 Apr 2023 11:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C19BC433EF;
        Thu,  6 Apr 2023 11:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780801;
        bh=bRMJMZZpgzwMBP+WHIcm5ARXb7ss27W3j3C0r5vPOTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V1TMTuRfr8f8w1mdijDZpDmTmmn+3XowpZnnTqYAxgP2fqeY9X1HU3yzhe7rvx6Pi
         MnuY53K0//VnnKt19Yj5/Ja3oZW+HIBc1TQ5utQiSucm76ATRLc2KUkY5iyYEiiPg2
         mUJeZWuiqwRLPNCc7kzNi4R3wlWNZa/cyk2vAGLSNm3uYs9ZW/dtLvVFrjIv9fuiTZ
         1b1MDbcrGjU10b+Spzr3/LHpyot1zbS1d6F3EQP7va+np5CqcWMIGeOVGJ/hvHXY6o
         jobgQOnFrrpdzR9iona3N0oxJ0UA7mU3sNBfYY44wiqmN7II4KBaDe2BCu7Pbb66hW
         VQ6dpn3R1FROg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Denose <jdenose@chromium.org>,
        Jonathan Denose <jdenose@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, wse@tuxedocomputers.com,
        mkorpershoek@baylibre.com, wsa+renesas@sang-engineering.com,
        chenhuacai@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/9] Input: i8042 - add quirk for Fujitsu Lifebook A574/H
Date:   Thu,  6 Apr 2023 07:33:08 -0400
Message-Id: <20230406113315.648777-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113315.648777-1-sashal@kernel.org>
References: <20230406113315.648777-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Denose <jdenose@chromium.org>

[ Upstream commit f5bad62f9107b701a6def7cac1f5f65862219b83 ]

Fujitsu Lifebook A574/H requires the nomux option to properly
probe the touchpad, especially when waking from sleep.

Signed-off-by: Jonathan Denose <jdenose@google.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230303152623.45859-1-jdenose@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 65c0081838e3d..9dcdf21c50bdc 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -601,6 +601,14 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
 	},
+	{
+		/* Fujitsu Lifebook A574/H */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FMVA0501PZ"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX)
+	},
 	{
 		/* Gigabyte M912 */
 		.matches = {
-- 
2.39.2


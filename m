Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6C6676D7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbjALOhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbjALOgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB4312771
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DCD5B81E71
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB74C433EF;
        Thu, 12 Jan 2023 14:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533626;
        bh=l1wuZT8MGIVYYTFKEkjyAeCihuBJ63AUnrtE5WvRH04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQ4taH0O2vLSTxZlxaNLeN+5HcLMxun71um5BK0l6pLnUaewcQcFIQuZtguZR1S73
         cv2Anoe8R3FfRoMdFGzXlTsSz5Kp37Ye7hZoX/2yQRnx/TC5eScrqdx6f0yr9AOXgS
         cnroXQ+1iVj5aNWcK9/dwJB91nXZUFqtTRjSjtMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/783] ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
Date:   Thu, 12 Jan 2023 14:53:36 +0100
Message-Id: <20230112135547.388978326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 953dbd1cef18ce9ac0d69c1bd735b929fe52a17e ]

KBL-R RVP platforms also use combojack, so we need to enable that
configuration for them.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221010121955.718168-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt298.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/rt298.c b/sound/soc/codecs/rt298.c
index dc0273a5a11f..1ca06213e3a3 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -1168,6 +1168,13 @@ static const struct dmi_system_id force_combo_jack_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Geminilake")
 		}
 	},
+	{
+		.ident = "Intel Kabylake R RVP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Kabylake Client platform")
+		}
+	},
 	{ }
 };
 
-- 
2.35.1




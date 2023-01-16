Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0AF66C845
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjAPQhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbjAPQg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E873E18B24
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AB5EB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F8CC433D2;
        Mon, 16 Jan 2023 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886356;
        bh=pqzx9OLU+wV5zVWFWVH3CWot1AsbeWFXXHKRM+pITZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mud/JcBP975BE1CHnDlTKuBZqa9vy8eAzaA7425KF6gXcFVORFd0NerwCDgW5uzj4
         lUMeDFdBE4Mfwcal1/6ItFqHFFMvl1Qhb3D78kkkO2eXfpFWGc/q45c09mkcGrcA4e
         z5z/YuBbhfIr4xgDcnKEi7MigbRIS+KudPjabkqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 399/658] ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
Date:   Mon, 16 Jan 2023 16:48:07 +0100
Message-Id: <20230116154927.839652534@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index f8c0f977206c..cc7eb34a641d 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -1166,6 +1166,13 @@ static const struct dmi_system_id force_combo_jack_table[] = {
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




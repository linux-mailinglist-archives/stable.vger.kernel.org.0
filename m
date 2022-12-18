Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419C165033E
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbiLRRAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 12:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbiLRQ6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:58:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6795B1CFF9;
        Sun, 18 Dec 2022 08:20:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7EAF3CE0B9A;
        Sun, 18 Dec 2022 16:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD934C433EF;
        Sun, 18 Dec 2022 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380423;
        bh=MAAF9cFBWVvZUUf8z3zc8SydFeMhTvgVuM+fYaPOVmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsT2lDLezcspyv1GAYNRBaP7TvwxLbtVftlFUMP3elG8VnU59xzYCXvX3eb6MxXst
         DSsCEB+DX7vIpAi8gdVs8n0P3qpCl6e4JG7kH4+f4iV/G6qivse9SEzyW8w0ZhACnB
         VR3Y5lF0kdw8yNEVo+S6m9wn6qd0n8dzRnMAIQL3jTspZa0fBDFoYHO2xeeWyp/fOg
         O6sC/aOhFAfYC/geMzOBde7aIsBQuQxXizTklBTdVjaUFaZYeVC2NMttZ8apxvw6xq
         GXEZogmHFIbNT4hOkzu41wI5ZY7uSTFGEbn/vznt6Wk6LaWonhIjNg36pKYcnFJJNC
         vc/0XRjKrRLfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 03/26] ASoC: codecs: rt298: Add quirk for KBL-R RVP platform
Date:   Sun, 18 Dec 2022 11:19:53 -0500
Message-Id: <20221218162016.934280-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 06cdba4edfe2..3181b91a025b 100644
--- a/sound/soc/codecs/rt298.c
+++ b/sound/soc/codecs/rt298.c
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id force_combo_jack_table[] = {
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


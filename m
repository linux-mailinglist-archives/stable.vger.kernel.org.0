Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327A9644056
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiLFJv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiLFJuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BB82250F;
        Tue,  6 Dec 2022 01:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA77AB818E4;
        Tue,  6 Dec 2022 09:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CADC433C1;
        Tue,  6 Dec 2022 09:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320199;
        bh=TqBnjsY6W9h8nVSTWhKJucNnSNV9DfSlrfaeFN+ZBDM=;
        h=From:To:Cc:Subject:Date:From;
        b=Tuhr277J49r+XybroMGnii1O6GQF3TSQ/eyFx2FfI77tszZwki0W/s/yLdQ7sDpft
         rvccw2ylRscyIMl/vMixKKYst416i/MeLISCcBimMYZ1lY8AyQqPYvSvq5yEH9CNu8
         lqOzkqCzk8UxoqkIaTxy3ovewNlcztcRLo3naJWoWJsIl2rmP/gPn1/F9Lp+oczyvY
         DQwDz+OJP6b4Lwg2E2LCWLl9UCj5L+RlssGqlwbYwyqZjxSRvX4BY0SM46afSOt8qt
         dSxGnSA/2pooP7vRxlhBussdMrpRlDnq7FL29bgLk2R/WwtOTuy3v/kSt9m9d0nKjm
         c/Owtx+g5Ixnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shengjiu.wang@gmail.com,
        Xiubo.Lee@gmail.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 01/12] ASoC: fsl_micfil: explicitly clear software reset bit
Date:   Tue,  6 Dec 2022 04:49:43 -0500
Message-Id: <20221206094955.987437-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 292709b9cf3ba470af94b62c9bb60284cc581b79 ]

SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined as
non volatile register, it still remain in regmap cache after set,
then every update of REG_MICFIL_CTRL1, software reset happens.
to avoid this, clear it explicitly.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1651925654-32060-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 9f90989ac59a..cb84d95c3aac 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -191,6 +191,17 @@ static int fsl_micfil_reset(struct device *dev)
 		return ret;
 	}
 
+	/*
+	 * SRES is self-cleared bit, but REG_MICFIL_CTRL1 is defined
+	 * as non-volatile register, so SRES still remain in regmap
+	 * cache after set, that every update of REG_MICFIL_CTRL1,
+	 * software reset happens. so clear it explicitly.
+	 */
+	ret = regmap_clear_bits(micfil->regmap, REG_MICFIL_CTRL1,
+				MICFIL_CTRL1_SRES);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.35.1


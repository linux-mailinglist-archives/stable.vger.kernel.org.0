Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423244EC016
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiC3Lss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343784AbiC3Lso (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E188C25E313;
        Wed, 30 Mar 2022 04:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F1B4615E7;
        Wed, 30 Mar 2022 11:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C0C340EE;
        Wed, 30 Mar 2022 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640816;
        bh=Qn2xz8unSOo35R95ApvqzpAB/fhcPz9d2W8mQpTVnmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUtJBAOV5s1wJ4X4mZW7aq8CaTIR8hkR/c2Zpq4O6im5r8a86IVGMSx9f70+lMDU+
         TAgptZhvBxY7jWhpq3HE+MMQoLPdwjKqtxdtocV4oTSrNock+SBKO/+GWkQMbVq9Hh
         HHaoBAS3P9kF42C+oriwOgKM7eBpNFZwBj6f4KsNUcz/GIQ+El6IGRBMk/FiYwScF/
         jBkcRJi0Ncg3L8X4oK+wQ7OEfyV1TQEpYi9IY77V7Qx4Zb2yRI7DSp+aP7OfVTZjg9
         E85GUPu+2gPQBRdHp+XcbTpNjg9ATB/RJdhtVlai4Vyi8P4zU8Jc2hEm3kSiyCxJ/+
         GGVbLrBYCpj7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Pavel Machek <pavel@denx.de>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 06/66] ASoC: sh: rz-ssi: Make the data structures available before registering the handlers
Date:   Wed, 30 Mar 2022 07:45:45 -0400
Message-Id: <20220330114646.1669334-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 0788785c78342d422f93b1c9831c2b2b7f137937 ]

Initialize the spinlock and make the data structures available before
registering the interrupt handlers.

Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20220110094711.8574-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index e8d98b362f9d..28400dbc5c06 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -975,6 +975,9 @@ static int rz_ssi_probe(struct platform_device *pdev)
 	ssi->playback.priv = ssi;
 	ssi->capture.priv = ssi;
 
+	spin_lock_init(&ssi->lock);
+	dev_set_drvdata(&pdev->dev, ssi);
+
 	/* Error Interrupt */
 	ssi->irq_int = platform_get_irq_byname(pdev, "int_req");
 	if (ssi->irq_int < 0)
@@ -1027,8 +1030,6 @@ static int rz_ssi_probe(struct platform_device *pdev)
 		return dev_err_probe(ssi->dev, ret, "pm_runtime_resume_and_get failed\n");
 	}
 
-	spin_lock_init(&ssi->lock);
-	dev_set_drvdata(&pdev->dev, ssi);
 	ret = devm_snd_soc_register_component(&pdev->dev, &rz_ssi_soc_component,
 					      rz_ssi_soc_dai,
 					      ARRAY_SIZE(rz_ssi_soc_dai));
-- 
2.34.1


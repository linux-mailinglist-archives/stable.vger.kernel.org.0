Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E44D540CDA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352621AbiFGSlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353385AbiFGSlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:41:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5FA5C671;
        Tue,  7 Jun 2022 10:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9203CE2422;
        Tue,  7 Jun 2022 17:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B92C34119;
        Tue,  7 Jun 2022 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624711;
        bh=k32QWyel7cy6/Oa0d/HxzbKatPGuFjuCdFxAh7YF7Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeb330liQ17SYstSFdXSzjvSGA1ROP7qvvLAzeGv0WA6DKnP95w1trTAwyh+tzlHV
         6WNs6lBUSuxgOCzwLwFFb7fpMEMais1VJgSMH2NsFqmU2ZcdkDzPfOdpfIdQQRMDge
         ogWaOC7YH45qe2n9E8sR6eCWZolr1hT5Ny6LOucc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/667] ASoC: sh: rz-ssi: Check return value of pm_runtime_resume_and_get()
Date:   Tue,  7 Jun 2022 19:01:30 +0200
Message-Id: <20220607164947.476379941@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit f04b4fb47d83b110a5b007fb2eddea862cfeb151 ]

The return value of pm_runtime_resume_and_get() needs to be checked to
avoid a usage count imbalance in the error case. This fix is basically
the same as 92c959bae2e5 ("reset: renesas: Fix Runtime PM usage"),
and the last step before pm_runtime_resume_and_get() can be annotated
as __must_check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/9fed506d-b780-55cd-45a4-9bd2407c910f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rz-ssi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sh/rz-ssi.c b/sound/soc/sh/rz-ssi.c
index 16de2633a873..7379b1489e35 100644
--- a/sound/soc/sh/rz-ssi.c
+++ b/sound/soc/sh/rz-ssi.c
@@ -1025,7 +1025,12 @@ static int rz_ssi_probe(struct platform_device *pdev)
 
 	reset_control_deassert(ssi->rstc);
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_resume_and_get(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0) {
+		pm_runtime_disable(ssi->dev);
+		reset_control_assert(ssi->rstc);
+		return dev_err_probe(ssi->dev, ret, "pm_runtime_resume_and_get failed\n");
+	}
 
 	ret = devm_snd_soc_register_component(&pdev->dev, &rz_ssi_soc_component,
 					      rz_ssi_soc_dai,
-- 
2.35.1




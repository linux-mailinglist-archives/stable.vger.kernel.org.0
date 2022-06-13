Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB75548EB4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiFMMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357792AbiFMM32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:29:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E566B5A17D;
        Mon, 13 Jun 2022 04:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E720FB80EB0;
        Mon, 13 Jun 2022 11:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0C1C34114;
        Mon, 13 Jun 2022 11:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118380;
        bh=8BoynCpX+u4I5/YqdrBHR3fbnfwcdAcU8vKEBjbNWAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgiFo8SgRTvBIoiFc009+n+runA1n1IKsoq1LhbC1B+G2/fCyCfLP0rzHF9QxkKqK
         VTmRbr8BacxIQhkzYiSArwq67g4RKHrJZ7psUXPAku9lnSCiP3neWKSop8tkyJ8PBD
         W5sHhsGqGh7LJrMPnK6dUvgS/be3aM6KfMqHWQAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/172] ASoC: fsl_sai: Fix FSL_SAI_xDR/xFR definition
Date:   Mon, 13 Jun 2022 12:10:07 +0200
Message-Id: <20220613094901.706782846@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit e4dd748dc87cf431af7b3954963be0d9f6150217 ]

There are multiple xDR and xFR registers, the index is
from 0 to 7. FSL_SAI_xDR and FSL_SAI_xFR is abandoned,
replace them with FSL_SAI_xDR0 and FSL_SAI_xFR0.

Fixes: 4f7a0728b530 ("ASoC: fsl_sai: Add support for SAI new version")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1653284661-18964-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 4bbcd0dbe8f1..8923c680f0e0 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -80,8 +80,8 @@
 #define FSL_SAI_xCR3(tx, ofs)	(tx ? FSL_SAI_TCR3(ofs) : FSL_SAI_RCR3(ofs))
 #define FSL_SAI_xCR4(tx, ofs)	(tx ? FSL_SAI_TCR4(ofs) : FSL_SAI_RCR4(ofs))
 #define FSL_SAI_xCR5(tx, ofs)	(tx ? FSL_SAI_TCR5(ofs) : FSL_SAI_RCR5(ofs))
-#define FSL_SAI_xDR(tx, ofs)	(tx ? FSL_SAI_TDR(ofs) : FSL_SAI_RDR(ofs))
-#define FSL_SAI_xFR(tx, ofs)	(tx ? FSL_SAI_TFR(ofs) : FSL_SAI_RFR(ofs))
+#define FSL_SAI_xDR0(tx)	(tx ? FSL_SAI_TDR0 : FSL_SAI_RDR0)
+#define FSL_SAI_xFR0(tx)	(tx ? FSL_SAI_TFR0 : FSL_SAI_RFR0)
 #define FSL_SAI_xMR(tx)		(tx ? FSL_SAI_TMR : FSL_SAI_RMR)
 
 /* SAI Transmit/Receive Control Register */
-- 
2.35.1




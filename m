Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10113A9A1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387788AbfFIRAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733207AbfFIRAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4EAE2146E;
        Sun,  9 Jun 2019 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099614;
        bh=SCl7zY2XNFbj6uj1WsrXzMY4+R0ki+XRnAv/3H+f4/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozOJwv7hJdfWke1J9fJFC/mHCcusyTkWkABL0T9J0WwbMW9Ag1w4VJCrF1TE9eDB5
         SsuItOJ7DLgBtFLd+28fP8awFLPz7c023WPrM8SDQ+5PfRmjwUuTd7n1olFTxmhlUo
         yTYLxGbAKGPWrjLJX6NjyC+pyL7S9bmDTXmuFYXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/241] ASoC: fsl_sai: Update is_slave_mode with correct value
Date:   Sun,  9 Jun 2019 18:40:46 +0200
Message-Id: <20190609164150.795689514@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ddb351145a967ee791a0fb0156852ec2fcb746ba ]

is_slave_mode defaults to false because sai structure
that contains it is kzalloc'ed.

Anyhow, if we decide to set the following configuration
SAI slave -> SAI master, is_slave_mode will remain set on true
although SAI being master it should be set to false.

Fix this by updating is_slave_mode for each call of
fsl_sai_set_dai_fmt.

Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 08b460ba06efc..61d2d955f26a6 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -260,12 +260,14 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	case SND_SOC_DAIFMT_CBS_CFS:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
+		sai->is_slave_mode = false;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFM:
 		sai->is_slave_mode = true;
 		break;
 	case SND_SOC_DAIFMT_CBS_CFM:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
+		sai->is_slave_mode = false;
 		break;
 	case SND_SOC_DAIFMT_CBM_CFS:
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
-- 
2.20.1




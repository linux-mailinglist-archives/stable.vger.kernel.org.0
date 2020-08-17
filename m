Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF932469CA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgHQPZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729776AbgHQPZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FD923442;
        Mon, 17 Aug 2020 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677956;
        bh=uV6qIhz4BQd4/2PvMwxiyKnrpeVYq28NqbseEiesAaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8R77W+8FrvnsvqRTTyyXNpUgZ6usGUSEG+CdRcpM8HHBuIiVeQ5G/o5AYAgZM3x3
         UhDdUK2Xz6Bi4+8Ogk0qvDtJLVDmdX4qxOO7UcEHsKMcH7jlG8jPB3THBks9K69sYC
         mVRhTeWb5ljBsw/eDooBT2kaNTnRy7N+oOXKfBTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 169/464] ASoC: fsl_easrc: Fix uninitialized scalar variable in fsl_easrc_set_ctx_format
Date:   Mon, 17 Aug 2020 17:12:02 +0200
Message-Id: <20200817143841.913407092@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 5748f4eb01a4df7a42024fe8bc7855f05febb7c5 ]

The "ret" in fsl_easrc_set_ctx_format is not initialized, then
the unknown value maybe returned by this function.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Link: https://lore.kernel.org/r/1592816611-16297-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index c6b5eb2d2af79..fff1f02dadfee 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -1133,7 +1133,7 @@ int fsl_easrc_set_ctx_format(struct fsl_asrc_pair *ctx,
 	struct fsl_easrc_ctx_priv *ctx_priv = ctx->private;
 	struct fsl_easrc_data_fmt *in_fmt = &ctx_priv->in_params.fmt;
 	struct fsl_easrc_data_fmt *out_fmt = &ctx_priv->out_params.fmt;
-	int ret;
+	int ret = 0;
 
 	/* Get the bitfield values for input data format */
 	if (in_raw_format && out_raw_format) {
-- 
2.25.1




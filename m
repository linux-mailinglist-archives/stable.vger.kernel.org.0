Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795BA49458
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbfFQVTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbfFQVTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C94D920861;
        Mon, 17 Jun 2019 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806392;
        bh=JEiq76uPupu5wSbzUc+/5bPp0j7rYM2+Zt2cLThnE4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIlcuzfAi7HZ2BRzNoCoaFZeuZX1PBdaavllCkJZGXXDSP6P5APkl/bOUhL7QVeGs
         J81yoqdz4dlIw6AJ8VM6g4dvBaj34Ad2l73oknvFgIGqEvKNZu5Dg3o0XYlB6BbvVf
         Q9IsyboU2KQjgd7oCozAbXWkjT5r9Ii1R/TTH5Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.1 035/115] ASoC: fsl_asrc: Fix the issue about unsupported rate
Date:   Mon, 17 Jun 2019 23:08:55 +0200
Message-Id: <20190617210801.774779911@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: S.j. Wang <shengjiu.wang@nxp.com>

commit b06c58c2a1eed571ea2a6640fdb85b7b00196b1e upstream.

When the output sample rate is [8kHz, 30kHz], the limitation
of the supported ratio range is [1/24, 8]. In the driver
we use (8kHz, 30kHz) instead of [8kHz, 30kHz].
So this patch is to fix this issue and the potential rounding
issue with divider.

Fixes: fff6e03c7b65 ("ASoC: fsl_asrc: add support for 8-30kHz
output sample rate")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_asrc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -282,8 +282,8 @@ static int fsl_asrc_config_pair(struct f
 		return -EINVAL;
 	}
 
-	if ((outrate > 8000 && outrate < 30000) &&
-	    (outrate/inrate > 24 || inrate/outrate > 8)) {
+	if ((outrate >= 8000 && outrate <= 30000) &&
+	    (outrate > 24 * inrate || inrate > 8 * outrate)) {
 		pair_err("exceed supported ratio range [1/24, 8] for \
 				inrate/outrate: %d/%d\n", inrate, outrate);
 		return -EINVAL;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA05F12193E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLPRxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:53:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfLPRxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:53:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F03206D3;
        Mon, 16 Dec 2019 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518825;
        bh=VwLAfRDoSzLbC0UpfvNv0VhAoPx0p0yCXc6MwO0YWpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhEmKLTiEWtl63kqkWAA6GysLYXzWsYS5pJjGivHpA76C2T+Di6DSQH1Kiku8fZuy
         Flu5NXa75GTaQa118PamAOosS1Zyi8ogmftp1KXW3+ORECd+cIWxJSsTmMJCbcdACr
         lH2m10s7LltxT4ApUO5XA8okup3xmb0lz24QkkUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young_X <YangX92@hotmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/267] ASoC: au8540: use 64-bit arithmetic instead of 32-bit
Date:   Mon, 16 Dec 2019 18:46:48 +0100
Message-Id: <20191216174857.443138049@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young_X <YangX92@hotmail.com>

[ Upstream commit cd7fdc45bc69a62b4e22c6e875f1f1aea566256d ]

Add suffix ULL to constant 256 in order to give the compiler complete
information about the proper arithmetic to use.

Notice that such constant is used in a context that expects an
expression of type u64 (64 bits, unsigned) and the following
expression is currently being evaluated using 32-bit arithmetic:

    256 * fs * 2 * mclk_src_scaling[i].param

Signed-off-by: Young_X <YangX92@hotmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8540.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/nau8540.c b/sound/soc/codecs/nau8540.c
index f9c9933acffb6..c0c64f90a61b7 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -548,7 +548,7 @@ static int nau8540_calc_fll_param(unsigned int fll_in,
 	fvco_max = 0;
 	fvco_sel = ARRAY_SIZE(mclk_src_scaling);
 	for (i = 0; i < ARRAY_SIZE(mclk_src_scaling); i++) {
-		fvco = 256 * fs * 2 * mclk_src_scaling[i].param;
+		fvco = 256ULL * fs * 2 * mclk_src_scaling[i].param;
 		if (fvco > NAU_FVCO_MIN && fvco < NAU_FVCO_MAX &&
 			fvco_max < fvco) {
 			fvco_max = fvco;
-- 
2.20.1




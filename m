Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01A762283
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbfGHP0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388838AbfGHP0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:26:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A4521707;
        Mon,  8 Jul 2019 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599591;
        bh=bZH1+pQXpXWoW32pkb6EuaJwhSCBdzAshRe8pVVsUI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsB1GXlQwwgbJ2+uf+fA6TKrL0o1q0qtvXRy9j9Kn7oC24QDNlLZZ0b2BfNiAUSBE
         NawdTQXrf9Na+DGwt9UJEBD7zViRbcMNNh7aIJm1qxpxvZCflIPZYTLM30NeDtcgNQ
         JoPup2EKYE9E9BL8XwmB65DEoVFp9xGPeRg2rBS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Viorel Suman <viorel.suman@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/90] ASoC: ak4458: rstn_control - return a non-zero on error only
Date:   Mon,  8 Jul 2019 17:12:38 +0200
Message-Id: <20190708150523.176590182@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 176a11834b65ec35e3b7a953f87fb9cc41309497 ]

snd_soc_component_update_bits() may return 1 if operation
was successful and the value of the register changed.
Return a non-zero in ak4458_rstn_control for an error only.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4458.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4458.c b/sound/soc/codecs/ak4458.c
index 58b6ca1de993..3bd57c02e6fd 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -272,7 +272,10 @@ static int ak4458_rstn_control(struct snd_soc_component *component, int bit)
 					  AK4458_00_CONTROL1,
 					  AK4458_RSTN_MASK,
 					  0x0);
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static int ak4458_hw_params(struct snd_pcm_substream *substream,
-- 
2.20.1




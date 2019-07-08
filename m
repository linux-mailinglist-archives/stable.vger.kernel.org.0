Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C92E623D1
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389901AbfGHPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389880AbfGHPa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:30:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C49B221537;
        Mon,  8 Jul 2019 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599856;
        bh=tES8anvbIE6i8CteTv1DhyTdmObCNtpLBKg9b6C/sKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gci1XkfMS5UYJC7VT2UqkBiizJP3yrsIvdmA1wXftArMqdE+7poi2FCWAjkkG0YgC
         JJlSVcfLduq4B6ji/3e3fFLCJMPs51xO7URZ0/6wO6XSsNajYRyR1eC9dfJxRdb66U
         +WjfZ2IHSlWTvkfezLjjvj5mBGjf78924Cq27RIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Viorel Suman <viorel.suman@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 12/96] ASoC: ak4458: rstn_control - return a non-zero on error only
Date:   Mon,  8 Jul 2019 17:12:44 +0200
Message-Id: <20190708150527.026869103@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
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
index 4c5c3ec92609..71562154c0b1 100644
--- a/sound/soc/codecs/ak4458.c
+++ b/sound/soc/codecs/ak4458.c
@@ -304,7 +304,10 @@ static int ak4458_rstn_control(struct snd_soc_component *component, int bit)
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




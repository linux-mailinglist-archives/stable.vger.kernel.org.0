Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768A71C149C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbgEANlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731397AbgEANlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488D9205C9;
        Fri,  1 May 2020 13:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340469;
        bh=h+yf3XfLMMIBkEtIRS1gwvCxk7zvY/MZ7YG4iM+WI90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUv08YIFvjhZrCtPjdgPK1DpgJdd3xm1jBSd0ympVSu7wh6MiXbcNN6S4h4HyRim+
         m1JpFjyjTLGdpWD7CnD36mC66vAI29ahsENQivtBEYioae8jESsDYdy9PFz65+vmJR
         Lk/xAseaNfmI7rnG2PoPrYZ5/KFdDUyss/Z9JHvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 83/83] ASoC: stm32: spdifrx: fix regmap status check
Date:   Fri,  1 May 2020 15:24:02 +0200
Message-Id: <20200501131543.348279295@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit a168dae5ea14283e8992d5282237bb0d6a3e1c06 upstream.

Release resources when exiting on error.

Fixes: 1a5c0b28fc56 ("ASoC: stm32: spdifrx: manage identification registers")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20200318144125.9163-2-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_spdifrx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -995,6 +995,8 @@ static int stm32_spdifrx_probe(struct pl
 
 	if (idr == SPDIFRX_IPIDR_NUMBER) {
 		ret = regmap_read(spdifrx->regmap, STM32_SPDIFRX_VERR, &ver);
+		if (ret)
+			goto error;
 
 		dev_dbg(&pdev->dev, "SPDIFRX version: %lu.%lu registered\n",
 			FIELD_GET(SPDIFRX_VERR_MAJ_MASK, ver),



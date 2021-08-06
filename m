Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49253E25BA
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244415AbhHFIWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243806AbhHFIUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0E861209;
        Fri,  6 Aug 2021 08:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628238031;
        bh=u1luN1sMFI7o5STBnQbpqlrcozJB2enfmjp0qualJQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tpk1460rh/5pqCobcrTFfaVTLvGNBa+KmM9NQG+W9nN5/AZSRcCYjWSYCfKVtm33l
         iDWQFYWwji8IiCND9CJMSC04MuI4hUXZxznHXpRfG9QdAfGnPLcWeZAgBwMOtgcUZf
         LvqNuZvQOusHdDXtwFIw2aqA2mVjsLYl3D8iM8/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 25/35] ASoC: ti: j721e-evm: Check for not initialized parent_clk_id
Date:   Fri,  6 Aug 2021 10:17:08 +0200
Message-Id: <20210806081114.554978326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@gmail.com>

[ Upstream commit 82d28b67f780910f816fe1cfb0f676fc38c4cbb3 ]

During probe the parent_clk_id is set to -1 which should not be used to
array index within hsdiv_rates[].

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210717122820.1467-3-peter.ujfalusi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index 017c4ad11ca6..265bbc5a2f96 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -197,7 +197,7 @@ static int j721e_configure_refclk(struct j721e_priv *priv,
 		return ret;
 	}
 
-	if (priv->hsdiv_rates[domain->parent_clk_id] != scki) {
+	if (domain->parent_clk_id == -1 || priv->hsdiv_rates[domain->parent_clk_id] != scki) {
 		dev_dbg(priv->dev,
 			"%s configuration for %u Hz: %s, %dxFS (SCKI: %u Hz)\n",
 			audio_domain == J721E_AUDIO_DOMAIN_CPB ? "CPB" : "IVI",
-- 
2.30.2




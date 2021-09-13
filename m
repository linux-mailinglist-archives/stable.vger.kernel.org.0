Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7B409588
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346530AbhIMOmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347168AbhIMOkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:40:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EDD261C48;
        Mon, 13 Sep 2021 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541354;
        bh=woE2grbPg3WPqA9HTL1cQBCX9cOnQFmfArs0J8oXWQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYjpQSgmL21YJSD5iG+QVj/wTWoMCrA4SZ2dRgtXUmZODbfYqGKZazmE/gb2LnK2l
         fxljDnO3vDNvcRn2TSSmtqD+1iUGNTIV4fG7KWRNaI5/FjrP5V4MLzCcURNzkwWza9
         Ud7H+iMXskUDqHj+zLUvLKVB3kXcUcMDPGt1DGI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 264/334] ASoC: wcd9335: Fix a double irq free in the remove function
Date:   Mon, 13 Sep 2021 15:15:18 +0200
Message-Id: <20210913131122.335788400@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7a6a723e98aa45f393e6add18f7309dfffa1b0e2 ]

There is no point in calling 'free_irq()' explicitly for
'WCD9335_IRQ_SLIMBUS' in the remove function.

The irqs are requested in 'wcd9335_setup_irqs()' using a resource managed
function (i.e. 'devm_request_threaded_irq()').
'wcd9335_setup_irqs()' requests all what is defined in the 'wcd9335_irqs'
structure.
This structure has only one entry for 'WCD9335_IRQ_SLIMBUS'.

So 'devm_request...irq()' + explicit 'free_irq()' would lead to a double
free.

Remove the unneeded 'free_irq()' from the remove function.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <0614d63bc00edd7e81dd367504128f3d84f72efa.1629091028.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 86c92e03ea5d..933f59e4e56f 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -4869,7 +4869,6 @@ static void wcd9335_codec_remove(struct snd_soc_component *comp)
 	struct wcd9335_codec *wcd = dev_get_drvdata(comp->dev);
 
 	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
-	free_irq(regmap_irq_get_virq(wcd->irq_data, WCD9335_IRQ_SLIMBUS), wcd);
 }
 
 static int wcd9335_codec_set_sysclk(struct snd_soc_component *comp,
-- 
2.30.2




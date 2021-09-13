Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85795408DE6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhIMNaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240824AbhIMNXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4DFC6121E;
        Mon, 13 Sep 2021 13:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539296;
        bh=kuGxC4jpQRf2+LVgyx74iLSAgTDM8xXeZXY0Z/SiXCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1Ff9j+kux7lLRhWs+6nlIN+kXqiSx6NWwJ44H/Li96yMdYS0N4m7D731S+0VXtgW
         zGOLymV/xmqGrG4VSQyvOPAzPCFCEEjPu9fNC0D3OGXlSrJ6LivF27ie2cbWghGMqe
         EO7f7DfO6RqU3hl496I9mMPgRq2wnbXOZNZtQSCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/144] ASoC: wcd9335: Fix a double irq free in the remove function
Date:   Mon, 13 Sep 2021 15:14:56 +0200
Message-Id: <20210913131051.778779352@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 81906c25e4a8..a31a20dcd6b5 100644
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




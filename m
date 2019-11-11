Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB93F7B8F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfKKSh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbfKKShZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 552D4204FD;
        Mon, 11 Nov 2019 18:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497444;
        bh=9ntRym/XPjnt7NSV2YOCgVwNheFmPcqUCuomFL+qEp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0yr0Hmp77X5GgeTL8T3/0Y9ckwRzFUq7O0PRMbYbKuKTS9hoD/QpFNbdRW5yK/Aa
         +WoChTWkr7F0Bxoq8km2OO3xM5gfFC/PB0qr5d3xqiiEucOuCfbVnr8HiL+BbFzYGM
         u8Jp/n1by1Vd8+vGyn4Kw+F7kWfJmCV9tmWOeD+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 057/105] ASoC: davinci: Kill BUG_ON() usage
Date:   Mon, 11 Nov 2019 19:28:27 +0100
Message-Id: <20191111181444.296252852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit befff4fbc27e19b14b343eb4a65d8f75d38b6230 upstream

Don't use BUG_ON() for a non-critical sanity check on production
systems.  This patch replaces with a softer WARN_ON() and an error
path.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/davinci/davinci-mcasp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1748,7 +1748,8 @@ static int davinci_mcasp_get_dma_type(st
 				PTR_ERR(chan));
 		return PTR_ERR(chan);
 	}
-	BUG_ON(!chan->device || !chan->device->dev);
+	if (WARN_ON(!chan->device || !chan->device->dev))
+		return -EINVAL;
 
 	if (chan->device->dev->of_node)
 		ret = of_property_read_string(chan->device->dev->of_node,



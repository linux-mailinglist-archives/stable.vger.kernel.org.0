Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEAD17FB11
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgCJNKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbgCJNKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:10:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 111E92468D;
        Tue, 10 Mar 2020 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845830;
        bh=zONuI80gsGahWrRGcfiy02MDNynaCVRJr9Gg28AWO9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmNKuKmS5xYyp48sEXZ9tC4b/mTUKzsqIo35VlIOnoXcYAPVlrNKgKPz84YCzwaLM
         SChVd1lRqBC5bnoaSBctveBjVBxdYcMJhGZDfi218gmJbS5BcDFiOAfzqyPWpqkTdj
         StIyGBodLtB3LSPsxQJ5xZQGyNGwpaDK79Qhk9vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Reichl <hias@horus.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 115/126] ASoC: pcm512x: Fix unbalanced regulator enable call in probe error path
Date:   Tue, 10 Mar 2020 13:42:16 +0100
Message-Id: <20200310124210.860839901@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit ac0a68997935c4acb92eaae5ad8982e0bb432d56 upstream.

When we get a clock error during probe we have to call
regulator_bulk_disable before bailing out, otherwise we trigger
a warning in regulator_put.

Fix this by using "goto err" like in the error cases above.

Fixes: 5a3af1293194d ("ASoC: pcm512x: Add PCM512x driver")
Signed-off-by: Matthias Reichl <hias@horus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200220202956.29233-1-hias@horus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/pcm512x.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -1438,13 +1438,15 @@ int pcm512x_probe(struct device *dev, st
 	}
 
 	pcm512x->sclk = devm_clk_get(dev, NULL);
-	if (PTR_ERR(pcm512x->sclk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(pcm512x->sclk) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err;
+	}
 	if (!IS_ERR(pcm512x->sclk)) {
 		ret = clk_prepare_enable(pcm512x->sclk);
 		if (ret != 0) {
 			dev_err(dev, "Failed to enable SCLK: %d\n", ret);
-			return ret;
+			goto err;
 		}
 	}
 



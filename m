Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1837CADF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbhELQck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241217AbhELQ0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF11161DCD;
        Wed, 12 May 2021 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834644;
        bh=RZwTi3JOH8de5QtDgZ1NXM6EHlhX4Taa6YD//ETDz+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5rUgP/NrpneDOu9VW2tAyeUGk3IYjzpLX4NFGM0f/IaTlsu9MtHMsncOQZWt+Aje
         FCpla+4cGmRI0nWFYGrgUBe1QovMj+Jerf1xgdsvP04weXA2gZEW1vz8f2pYQkFb9I
         Gdr14wPR6NJnQtHio9ePtBmxWyzEGeSiOV0s7gwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 026/677] ASoC: samsung: tm2_wm5110: check of of_parse return value
Date:   Wed, 12 May 2021 16:41:12 +0200
Message-Id: <20210512144838.096868755@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit d58970da324732686529655c21791cef0ee547c4 upstream.

cppcheck warning:

sound/soc/samsung/tm2_wm5110.c:605:6: style: Variable 'ret' is
reassigned a value before the old one has been
used. [redundantAssignment]
 ret = devm_snd_soc_register_component(dev, &tm2_component,
     ^
sound/soc/samsung/tm2_wm5110.c:554:7: note: ret is assigned
  ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
      ^
sound/soc/samsung/tm2_wm5110.c:605:6: note: ret is overwritten
 ret = devm_snd_soc_register_component(dev, &tm2_component,
     ^

The args is a stack variable, so it could have junk (uninitialized)
therefore args.np could have a non-NULL and random value even though
property was missing. Later could trigger invalid pointer dereference.

There's no need to check for args.np because args.np won't be
initialized on errors.

Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2 board")
Cc: <stable@vger.kernel.org>
Suggested-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210312180231.2741-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/samsung/tm2_wm5110.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/samsung/tm2_wm5110.c
+++ b/sound/soc/samsung/tm2_wm5110.c
@@ -553,7 +553,7 @@ static int tm2_probe(struct platform_dev
 
 		ret = of_parse_phandle_with_args(dev->of_node, "i2s-controller",
 						 cells_name, i, &args);
-		if (!args.np) {
+		if (ret) {
 			dev_err(dev, "i2s-controller property parse error: %d\n", i);
 			ret = -EINVAL;
 			goto dai_node_put;



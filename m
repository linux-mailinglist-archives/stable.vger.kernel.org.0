Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB739AA858
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388610AbfIEQSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:18:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33973 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388631AbfIEQSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:18:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so1698197pgc.1
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 09:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k4RSHQziswwPF3IEl7odNlbX/Lq1Hx75YDWK/+CVFu0=;
        b=jZZB1l94YWLd3tFIaGQ47yvMyJb9LlEazs2Ow8RBBjQ4l/r+vNhmddIWpMfHfHXs50
         78rWPPNCOz1OQu1AmHck6xNxXoRE7CFw9P+2slSZQz2Ys6D042/onIrEufTy+6xGnf7G
         /W7VbSFrbc056Zl/UdlRSDhj5hSjjoWsrULBTO1dp2b+2wVkNBYy15jzvUSO7Yol26Pq
         +a0ju3yHvCNmc2ezasYLStXloGX/OXTLGO31IarwZm/OPn8nU0nkbRODmTltiIBUdlzi
         njdrh0EUYg8SUhgdMLrNIUsilQw7WpjaCy9U6aj+BbrkPvrH3K1Yod5NAymx6bhyqYRw
         48AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k4RSHQziswwPF3IEl7odNlbX/Lq1Hx75YDWK/+CVFu0=;
        b=GlM/YUcz7Od4HqEvu1Psvx0UbG6tZZu9atgBuR4NpWoj63qova+Hp1985Movzjh5yp
         FD+2bEf/XZasI7R2NzZrWx0tIC3NvZOAGffODrjnzUd846Do8zspYgCvUilcpZGGoZHo
         qJBmHiW2xLQdcVU5PpnKKr/JJsEuX3zjBs5bcETqA3xPhYOAZeMIM1G0kvJzhWSNh+OM
         7pNMsZovNq1Re2MOk4NvdgdRu0qbG88mXQDUpWs7Os4P+6KOCzAtcLLmwhFuucVlrWYK
         XEZG0FJW7u7AXyXyDv3Qy1x4kMG5M+XdwDdysCtoHIjl4XBRe/JQfLW2VVJ1wxB0cJLZ
         10Gg==
X-Gm-Message-State: APjAAAUG9VQrR/JDjpmWBgcCT/DlMqJzMCl5rFXnQv1gqrOJF4xQHCkY
        kbsnTGE5pEWzTgdJAnaicnN4upD3kOs=
X-Google-Smtp-Source: APXvYqylgGgnlf/Z0Orza9qJRrWxcszrwnK+vdVT7tg0cYX2LQXbbeSPDVM6mlYFYgUjBYVURutriw==
X-Received: by 2002:a63:714a:: with SMTP id b10mr4066928pgn.25.1567700299222;
        Thu, 05 Sep 2019 09:18:19 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m129sm6324005pga.39.2019.09.05.09.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 09:18:18 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [BACKPORT 4.14.y 15/18] ASoC: davinci: Kill BUG_ON() usage
Date:   Thu,  5 Sep 2019 10:17:56 -0600
Message-Id: <20190905161759.28036-16-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905161759.28036-1-mathieu.poirier@linaro.org>
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
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
---
 sound/soc/davinci/davinci-mcasp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index af6cd8b874f5..b4e6f4a04cb6 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1748,7 +1748,8 @@ static int davinci_mcasp_get_dma_type(struct davinci_mcasp *mcasp)
 				PTR_ERR(chan));
 		return PTR_ERR(chan);
 	}
-	BUG_ON(!chan->device || !chan->device->dev);
+	if (WARN_ON(!chan->device || !chan->device->dev))
+		return -EINVAL;
 
 	if (chan->device->dev->of_node)
 		ret = of_property_read_string(chan->device->dev->of_node,
-- 
2.17.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB51341F
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 21:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfECTpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 15:45:51 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39822 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfECTpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 15:45:51 -0400
Received: by mail-io1-f66.google.com with SMTP id m7so3897253ioa.6
        for <stable@vger.kernel.org>; Fri, 03 May 2019 12:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aq2s3BnJgyxTeXCjYfqYbnyB07LuUnvkG9UrQRt2rnU=;
        b=iXAwz7Uf0odYcDlw8VydAoGs5uvncr1Fi5u8a46qCPcMqVkH2NdJwkSGgYPHJjJ+K+
         X9ezDz2GYUsNQ9xFNaXLGfRkIcFKpX3RHNBG8SZrZOzQTMk5mGGBSi3U6kdXQJxeGLQj
         cLCDrEbKt7i2uFLalnL6R5hExNEOlBZu+Tdew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aq2s3BnJgyxTeXCjYfqYbnyB07LuUnvkG9UrQRt2rnU=;
        b=B2LbAbbWm6OxouJAcvAur/nFivEvPmFjQn8B6V11rlegSizbMyO6AGqiqW9/jXCa1G
         +Ef8RlKAjtzPQ2DSJ0a5dxChgh6+tTyJJc2TL8JcvHY6wNNYslU0RZ9oobJ7rr6SRsVu
         Z7Q9bRWEtIJ/JV8zXQmQ5WlXD6vhno4+PEy9VMfyr1HFBVbbE9dPjfaE9xGvYJPhBWD3
         2mgHtl+/Y+mq8tF9LO5ooQ5XsNWzfMkweTUfRq2y3HjkfnN/sL0+Q+dSTeO+SkSJqE4o
         IawkIOL6hyNNsnd8ZGOX9x/uCCFdzqEc1TNlytPdpq2UxrQyZla8+j5Bz/UGvgbIj+Us
         1Hfg==
X-Gm-Message-State: APjAAAVPhMsiYFs1BzeA4POcJTDaTAEhrNIj2yW2XduOZl61j0p/cQrC
        wyeQ53m1wFuqQRFwauvw6VXo8g==
X-Google-Smtp-Source: APXvYqx/c9CPkqgGv7GR57M5SbQdUCUtT77i9nI+z4D/o1f4q7bwVxYuDTtpqUfJNKEKDBQ66kDAWw==
X-Received: by 2002:a6b:e616:: with SMTP id g22mr482428ioh.231.1556912750752;
        Fri, 03 May 2019 12:45:50 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id 81sm1347273itd.41.2019.05.03.12.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 12:45:49 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ross Zwisler <zwisler@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [linux-4.4.y PATCH] ASoC: Intel: avoid Oops if DMA setup fails
Date:   Fri,  3 May 2019 13:45:03 -0600
Message-Id: <20190503194503.77923-1-zwisler@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190429182710.GA209252@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Zwisler <zwisler@chromium.org>

commit 0efa3334d65b7f421ba12382dfa58f6ff5bf83c4 upstream.

Currently in sst_dsp_new() if we get an error return from sst_dma_new()
we just print an error message and then still complete the function
successfully.  This means that we are trying to run without sst->dma
properly set up, which will result in NULL pointer dereference when
sst->dma is later used.  This was happening for me in
sst_dsp_dma_get_channel():

        struct sst_dma *dma = dsp->dma;
	...
        dma->ch = dma_request_channel(mask, dma_chan_filter, dsp);

This resulted in:

   BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
   IP: sst_dsp_dma_get_channel+0x4f/0x125 [snd_soc_sst_firmware]

Fix this by adding proper error handling for the case where we fail to
set up DMA.

This change only affects Haswell and Broadwell systems.  Baytrail
systems explicilty opt-out of DMA via sst->pdata->resindex_dma_base
being set to -1.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Cc: stable@vger.kernel.org
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---

The upstream patch applied cleanly to all stable trees except
linux-4.4.y and linux-3.18.y.  This is the backport for linux-4.4.y, and
the code I'm fixing was introduced in v4.0 so there is no need for a
linux-3.18.y backport.

The upstream patch is currently in Mark Brown's tree:

https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git/log/?h=for-next

Is that good enough, or should I resend after it's been merged in the
v5.2 merge window?

---
 sound/soc/intel/common/sst-dsp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/sst-dsp.c b/sound/soc/intel/common/sst-dsp.c
index c9452e02e0dda..c0a50ecb6dbda 100644
--- a/sound/soc/intel/common/sst-dsp.c
+++ b/sound/soc/intel/common/sst-dsp.c
@@ -463,11 +463,15 @@ struct sst_dsp *sst_dsp_new(struct device *dev,
 		goto irq_err;
 
 	err = sst_dma_new(sst);
-	if (err)
-		dev_warn(dev, "sst_dma_new failed %d\n", err);
+	if (err)  {
+		dev_err(dev, "sst_dma_new failed %d\n", err);
+		goto dma_err;
+	}
 
 	return sst;
 
+dma_err:
+	free_irq(sst->irq, sst);
 irq_err:
 	if (sst->ops->free)
 		sst->ops->free(sst);
-- 
2.21.0.1020.gf2820cf01a-goog


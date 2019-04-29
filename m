Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC056EA0E
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 20:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfD2SZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 14:25:53 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:37024 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbfD2SZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 14:25:53 -0400
Received: by mail-it1-f196.google.com with SMTP id r85so574790itc.2
        for <stable@vger.kernel.org>; Mon, 29 Apr 2019 11:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YaQCnzzh+3p/v5Fojy+snkCdhoa+2CZox1xOwkyLqvU=;
        b=J4S+dRaERgYYJqnVpVLtPqQznX5dFlnBdW1GSin1hyFvVPaVFzBMJJghFLtjWDxjRT
         v4iQjjYiEm5qqJHFhcTf+I2XtMweu48chGehJmqyEzO/Qd5UGSJCqE5O7ITg1jCUrp1O
         sLkB+tB1sLss3OVRYXkzt7MWCq2RCJl+FymYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YaQCnzzh+3p/v5Fojy+snkCdhoa+2CZox1xOwkyLqvU=;
        b=TvpId0u0Xyc2ylO5PclEbL1pPbfdE9CbphKhGFq2O3MO1FkCQv7vZH10SLu+c7nPs+
         oZrsrtjsy9OlrZmDUwib9YlY/QzP1l/UtIS9jzJkyzrHnoACvgvB4OWSCcLLk0pL4FjJ
         VyjUzxcXJmAfIJDYgT7fXI6HGcHKyvgzw9B1+zrctrBqRnmpuJlTYpN4/Pn0jFN2dM7s
         aYMh4qk2dwE3l4VQMKtmcecpO7ub/10SCfdJPG5DUQS/kgE+Y9XqThlFidl1FKdoMFOK
         h/TUEMHzGIlpIZFmP4JAaedP5oZDUgi8JK4PFQqLTLBhw582Pbp31fgaUGmJLAjy7YIT
         nv0g==
X-Gm-Message-State: APjAAAWBVO+TqOkn8giEhQ4iW2Yw12/vP6AfxonsQMJT2ST1m33ullV2
        isa47F8q6UNaiaykQ1bIJzQvaw==
X-Google-Smtp-Source: APXvYqwBCurYe1oxJjzdJiVGjz+EDb8ToH9Z6RTcJkNpjitcglw/xKq/Iljl45Uzy6HrBv+Pj9q+6w==
X-Received: by 2002:a05:660c:24e:: with SMTP id t14mr371088itk.50.1556562352791;
        Mon, 29 Apr 2019 11:25:52 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id y199sm12894585iof.88.2019.04.29.11.25.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 11:25:51 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Jie Yang <yang.jie@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        alsa-devel@alsa-project.org, stable@vger.kernel.org
Subject: [PATCH v2] ASoC: Intel: avoid Oops if DMA setup fails
Date:   Mon, 29 Apr 2019 12:25:17 -0600
Message-Id: <20190429182517.210909-1-zwisler@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
In-Reply-To: <0b030b85-00c8-2e35-3064-bb764aaff0f6@linux.intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Changes in v2:
 - Upgraded the sst_dma_new() failure message from dev_warn() to dev_err()
   (Pierre-Louis).
 - Noted in the changelog that this change only affects Haswell and
   Broadwell (Pierre-Louis).

---
 sound/soc/intel/common/sst-firmware.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/sst-firmware.c b/sound/soc/intel/common/sst-firmware.c
index 1e067504b6043..f830e59f93eaa 100644
--- a/sound/soc/intel/common/sst-firmware.c
+++ b/sound/soc/intel/common/sst-firmware.c
@@ -1251,11 +1251,15 @@ struct sst_dsp *sst_dsp_new(struct device *dev,
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
2.21.0.593.g511ec345e18-goog


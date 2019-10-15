Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76ABD6FC9
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 09:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfJOG7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 02:59:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37384 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfJOG7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 02:59:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so11537729pgi.4
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 23:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s8ax0pNsjS34NQgcw7z1oLLF7sOclh4TjvoGbZiiLB8=;
        b=LqiY4+eTQkVeBC1lMPF7YYxbluIbw9VUU8JZtS9m6oR7ctp0sCqy0oj4hTdQIc/l15
         4DKDY8XL6sekA8doxm7hTPg4AYK71o2L3A+NMbrt5Pj3intEUQQqTlIub45xUtEBQHHY
         uD4GaZUTARVLXiFJ2UuOxQ+Qalc/tgumAzfr1ixW/QDNGrfDlhnouuNdzqQQA78tRker
         NJhTGUVomZcZO0b1u18SHLHzElT0gFfFT5bFTusN5tdKNIcWQzVZ+SPUAJYdPIe4kOwX
         TK42n/0c8B70Kd735fQhYiGw/4K/tVRxsZFiYCozdTENJ+8gZ76uk2nf4TNCdtBx/UY7
         2uHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s8ax0pNsjS34NQgcw7z1oLLF7sOclh4TjvoGbZiiLB8=;
        b=IaS/zlxDee1pWZMkqFUcAumazpvEOmZsI+Ua0trf9Q4esa5NR0tw+Z8vP2vAHEJlsC
         L8dAP8LspsTz3BmnLcJZdvm252OIfFdtRk/MA1lBWrJFsB57EXQhj+hgWgL4G0w+7Y7h
         CO4pxyOqG5boiVtyZZ3kIl2FiN5I/px5cJRgh6h64E+ICEaLarTWBhQY6Y6TtyZ4TrLa
         ls/4ApPOGENb33SsXlyK2OMIQ6hz9kpnzYzoi4T7YTXnPn07uHh1hUNP1jYrt4pAGu7J
         TT7TCtlidXWto57sCJGZuwffnG/NZx6DaDlMBP1DUtp1CPrAChyLypY9j1mDEG7cPx3s
         3qDA==
X-Gm-Message-State: APjAAAVKanDw7qUMkjEO7Sgg8JEuJi4X/cL/2R3g1qk/qcPUdQN+JY1d
        6XfSBImoKepr5/TOMGiC/8P/3l11cDo=
X-Google-Smtp-Source: APXvYqyVrARJeunnXPSfERMIsMVbKXz1zoefqYCxcoqCdlJ+Flg5NAbVu6m+pTIqUmhkYPT5g+KCtw==
X-Received: by 2002:a62:6411:: with SMTP id y17mr37212371pfb.24.1571122780487;
        Mon, 14 Oct 2019 23:59:40 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id i16sm17952646pfa.184.2019.10.14.23.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:59:39 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 2/4] ASoC: pcm3168a: The codec does not support S32_LE
Date:   Tue, 15 Oct 2019 00:59:35 -0600
Message-Id: <20191015065937.23169-2-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015065937.23169-1-mathieu.poirier@linaro.org>
References: <20191015065937.23169-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 7b2db65b59c30d58c129d3c8b2101feca686155a upstream

24 bits is supported in all modes and 16 bit only when the codec is slave
and the DAI is set to RIGHT_J.

Remove the unsupported sample format.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20190919071652.31724-1-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/codecs/pcm3168a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index e3de1ff3b6c2..439e40245bb0 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -24,8 +24,7 @@
 
 #define PCM3168A_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
 			 SNDRV_PCM_FMTBIT_S24_3LE | \
-			 SNDRV_PCM_FMTBIT_S24_LE | \
-			 SNDRV_PCM_FMTBIT_S32_LE)
+			 SNDRV_PCM_FMTBIT_S24_LE)
 
 #define PCM3168A_FMT_I2S		0x0
 #define PCM3168A_FMT_LEFT_J		0x1
-- 
2.17.1


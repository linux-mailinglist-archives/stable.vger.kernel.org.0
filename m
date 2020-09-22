Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE0274136
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVLrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgIVLpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 07:45:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172D9C061755;
        Tue, 22 Sep 2020 04:43:46 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so1320430pjr.3;
        Tue, 22 Sep 2020 04:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2VjYly8YXl5EI4Tg/+laJM2UumOWuwQAVbPJYyz4D0=;
        b=TZur9F8PDyYbsDiO0VBy9PuSALAJtXA7A3MOMzpLhDzIVb4bRaNHoZ5KRp/WqZlDY/
         h3sNg9bhUDTzI5UPswWyPVcIHCXAsiGuyYgnwVoIyBBZdzaVESTe5ESdNqmwZKrAHxs2
         6VD1IESsegZQcSGLs3E0wN2nGuLVX6tnTyhtPqzNuFjznNQZyG2Yg+m0JaWoxLqW+ErI
         GA9OkKJ62D0CNxqKsr6+NYXAANEM9nkerzIrl779cGFivYG6HKhfglG9deCwxut/I1/3
         Y23S++Rz25MI8+9+nQbTEfN+W0x5ixw5lA28hE0R9TovGEuoyATkFjN83OBliSTTS4K0
         tC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2VjYly8YXl5EI4Tg/+laJM2UumOWuwQAVbPJYyz4D0=;
        b=O1VfOX2f8kHVPTN/w4NOycgtQEbLSLJNTdJ03KJblSxW+b6d/2H30qN2naLyWfsoHT
         gR4vcBwNSD6rMKAGn2O6vTRSUrQMlZJJ7JW3MnlGQgJuy1+iIFCARtcrvhGfcpEUVL1P
         gAWrpeauO95RtlSQzKkWle0BNZPNmGXcLIr4qeD1VOWH47EWh00+vliosBI6oojWCD3D
         GLa7gY1aami5gj9Y0mPrXauDzgl/yViw5p9F2u7G9IfkQysILaWk4Sp11kCQgDrXh+OM
         d/VccO5Qu7fzVt1zEc3payhT2PvCC5m9IBPciXXcNcd92fUSsfR7Tb3vitIAmDZOBtRz
         fncw==
X-Gm-Message-State: AOAM5304yvqrtuyCn/Y0wnJrRdMDuN4Zc9rNyNGAnAswDa9SLDSQqx2g
        dbYCKLvRAQwhHWhIYrAPtvMPEPbpesCZAA==
X-Google-Smtp-Source: ABdhPJzjspDLviipX8iGk3qMnTqf3IErP0S4c3BsVZUA3+sm4i0FljmNVmIT/3nchofuaHPwXUi95g==
X-Received: by 2002:a17:90a:6741:: with SMTP id c1mr3331202pjm.6.1600775025377;
        Tue, 22 Sep 2020 04:43:45 -0700 (PDT)
Received: from guoguo-omen.lan ([156.96.148.94])
        by smtp.gmail.com with ESMTPSA id r16sm2179486pjo.19.2020.09.22.04.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 04:43:44 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-spi@vger.kernel.org
Cc:     bayi.cheng@mediatek.com, Chuanhong Guo <gch981213@gmail.com>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spi-mtk-nor: fix timeout calculation overflow
Date:   Tue, 22 Sep 2020 19:42:59 +0800
Message-Id: <20200922114317.2935897-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CLK_TO_US macro is used to calculate potential transfer time for various
timeout handling. However it overflows on transfer bigger than 512 bytes
because it first did (len * 8 * 1000000).
This controller typically operates at 45MHz. This patch did 2 things:
1. calculate clock / 1000000 first
2. add a 4M transfer size cap so that the final timeout in DMA reading
   doesn't overflow

Fixes: 881d1ee9fe81f ("spi: add support for mediatek spi-nor controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---
 drivers/spi/spi-mtk-nor.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 6e6ca2b8e6c82..619313db42c0e 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -89,7 +89,7 @@
 // Buffered page program can do one 128-byte transfer
 #define MTK_NOR_PP_SIZE			128
 
-#define CLK_TO_US(sp, clkcnt)		((clkcnt) * 1000000 / sp->spi_freq)
+#define CLK_TO_US(sp, clkcnt)		DIV_ROUND_UP(clkcnt, sp->spi_freq / 1000000)
 
 struct mtk_nor {
 	struct spi_controller *ctlr;
@@ -177,6 +177,10 @@ static int mtk_nor_adjust_op_size(struct spi_mem *mem, struct spi_mem_op *op)
 	if ((op->addr.nbytes == 3) || (op->addr.nbytes == 4)) {
 		if ((op->data.dir == SPI_MEM_DATA_IN) &&
 		    mtk_nor_match_read(op)) {
+			// limit size to prevent timeout calculation overflow
+			if (op->data.nbytes > 0x2000000)
+				op->data.nbytes = 0x2000000;
+
 			if ((op->addr.val & MTK_NOR_DMA_ALIGN_MASK) ||
 			    (op->data.nbytes < MTK_NOR_DMA_ALIGN))
 				op->data.nbytes = 1;
-- 
2.26.2


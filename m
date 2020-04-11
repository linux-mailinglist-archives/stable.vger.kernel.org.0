Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7291A51BF
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgDKMNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgDKMNn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007A620787;
        Sat, 11 Apr 2020 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607223;
        bh=s0u7lDLLVe++4Weesyk9XvhvqRchgRX/r1SYmiD7pWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJottES7q5+yMgOO/2JrcLX53mRtovFGF88cHXnWozULJidR84bSMyRT5rxht0ub4
         7nMdyuID93Ks5AEjEu9OGuqGToE7Y5C8V4p5IK1CvqcKPjJrswNyZRU6EwlmVp3BHa
         D2t3fFoEwzPzd6JFCr3Fsz/ZmFUN7CgYZsxR1+6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 24/38] ASoC: jz4740-i2s: Fix divider written at incorrect offset in register
Date:   Sat, 11 Apr 2020 14:09:08 +0200
Message-Id: <20200411115440.407623464@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 9401d5aa328e64617d87abd59af1c91cace4c3e4 upstream.

The 4-bit divider value was written at offset 8, while the jz4740
programming manual locates it at offset 0.

Fixes: 26b0aad80a86 ("ASoC: jz4740: Add dynamic sampling rate support to jz4740-i2s")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200306222931.39664-2-paul@crapouillou.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/jz4740/jz4740-i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -92,7 +92,7 @@
 #define JZ_AIC_I2S_STATUS_BUSY BIT(2)
 
 #define JZ_AIC_CLK_DIV_MASK 0xf
-#define I2SDIV_DV_SHIFT 8
+#define I2SDIV_DV_SHIFT 0
 #define I2SDIV_DV_MASK (0xf << I2SDIV_DV_SHIFT)
 #define I2SDIV_IDV_SHIFT 8
 #define I2SDIV_IDV_MASK (0xf << I2SDIV_IDV_SHIFT)



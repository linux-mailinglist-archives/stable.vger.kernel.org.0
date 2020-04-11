Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B71A510E
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgDKMTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgDKMTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E086A21556;
        Sat, 11 Apr 2020 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607585;
        bh=5hacpNxYZe7Twig3n1RyG6eCOLtCL2UyVsUDwGr3d/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKz9gE5zt4r1/x0bBpdX5M/iTTe0rhWGclFeMCFqVfcrbZNl2wypBIo1Djy1Ri/5n
         bV7veONgVQLgiloyaIY3xijkAEYtMYsSyMVoRCrds41uqrYRADDEbSj6YKS+Pn5iNm
         uqZW/4XqE+JJ1YbaKL0+u4YrVYu68I7lwR1bM8YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 37/44] ASoC: jz4740-i2s: Fix divider written at incorrect offset in register
Date:   Sat, 11 Apr 2020 14:09:57 +0200
Message-Id: <20200411115500.546616696@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
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
@@ -83,7 +83,7 @@
 #define JZ_AIC_I2S_STATUS_BUSY BIT(2)
 
 #define JZ_AIC_CLK_DIV_MASK 0xf
-#define I2SDIV_DV_SHIFT 8
+#define I2SDIV_DV_SHIFT 0
 #define I2SDIV_DV_MASK (0xf << I2SDIV_DV_SHIFT)
 #define I2SDIV_IDV_SHIFT 8
 #define I2SDIV_IDV_MASK (0xf << I2SDIV_IDV_SHIFT)



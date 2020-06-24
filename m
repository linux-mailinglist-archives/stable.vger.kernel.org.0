Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6B2076C6
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404135AbgFXPH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391192AbgFXPHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:07:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664E6C061795
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:15 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so2863735wmh.2
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 08:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gtJAcvpHkuLRDrUsq1eY3z1bY+z7q8TiiXjibqyd6Ck=;
        b=ZHnjSn2WorVvPlhnsW05PjkW49hRNPgq84FENEFtuoQWoLFoS5Koxe/dFywbKRMHXL
         3TdXrKvSsAttDlfRMZtJGsuGsj/a+hJcx94EmcpOadjkOkkb+KaWqiOYgNy6L6Yx11WO
         +baxZJlc03ZWuHtQboIEUm9C0m3an2F/wAOR3zMqIO+0e0yZcoFn/dKH/AZytJKBvXIf
         kasqyP3fjB5JUNwQho/QWyRHJ3YJOyhWE3+Oe40vlAuTWYeoqbw7Ezbto0uUymTcO6fp
         rAU9JBU5tdSYDQHnIyQdY1pyBRF0zOeb8P/DzpPmVAGVbd1L9Mlm8deCmJcpHyEmu7Vk
         irqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gtJAcvpHkuLRDrUsq1eY3z1bY+z7q8TiiXjibqyd6Ck=;
        b=eKIMG45PUV1nndNd8/NR4hrTBVYzIBvDQ8/SyZj19NLCLLWUYeBFXnkclCUqC9OnfR
         E3mEqNaH8tWFvugdjqEXTM7ShVLBDHrEd+3KNzDhN+RJncZEuYLJwZNy3Uiuf0qZ+4nT
         s97gdqw4CO+BZlakaRCnV4JNYHpuGAtp1FOUiHK5HBhD8UYlrjjF6gwH/s14NE7Qtsts
         Z7LAzioCx1K7n2m2ShVi9inJsxj52X+YfsdMR6Ms9QOSVZE57cR/H6os6PLCTN5KaYsj
         RYbA2aFk0cJY2Mv7GJypSpiL0ykfPV1ZycStObZKissWQT3BgVFFASX1mxh9+glI+Ga6
         054A==
X-Gm-Message-State: AOAM532sG6RhPTdKEGTd/AkCeEPONBr2fnCrQfT+zdFCdUAeyX2/EAgy
        e0Px4mhhifGR1f5qQ36UoASa8A==
X-Google-Smtp-Source: ABdhPJxagKb1wXFKsg3BjteSAxqyibenBVKBU8QYTY4DNUpO9PPoz2ukw2LgHjBi8SkOZzRYlyySUA==
X-Received: by 2002:a1c:e303:: with SMTP id a3mr12187899wmh.26.1593011234076;
        Wed, 24 Jun 2020 08:07:14 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id h14sm11543361wrt.36.2020.06.24.08.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:07:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Kai Svahn <kai.svahn@nokia.com>, Syed Khasim <x0khasim@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 02/10] mfd: twl4030-irq: Fix cast to restricted __le32 warning
Date:   Wed, 24 Jun 2020 16:06:56 +0100
Message-Id: <20200624150704.2729736-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624150704.2729736-1-lee.jones@linaro.org>
References: <20200624150704.2729736-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Silences Sparse warning(s):

 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32
 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32
 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32
 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32
 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32
 drivers/mfd/twl4030-irq.c:573:40: warning: cast to restricted __le32

Cc: <stable@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kai Svahn <kai.svahn@nokia.com>
Cc: Syed Khasim <x0khasim@ti.com>
Cc: linux-omap@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index d05bc74daba32..ab417438d1faa 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -561,7 +561,7 @@ static inline int sih_read_isr(const struct sih *sih)
 	int status;
 	union {
 		u8 bytes[4];
-		u32 word;
+		__le32 word;
 	} isr;
 
 	/* FIXME need retry-on-error ... */
-- 
2.25.1


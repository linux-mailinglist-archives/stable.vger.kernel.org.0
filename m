Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C292206475
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389551AbgFWVVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404249AbgFWVVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 17:21:51 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BB1C061573;
        Tue, 23 Jun 2020 14:21:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l188so7235107qkf.10;
        Tue, 23 Jun 2020 14:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JyKLP13MA3we/vWXo7vrVA6xMNeRPMkMoZjirv2W5f8=;
        b=frQCVrMNN/+WhRNV+xlYiJ59hqptoPUZlFyQEi5Nxs1ZDTbZCHFzkP5Fy+KHZmFx42
         4IJltfqqSa4cluvGdrB4QfYoiCddWuCbVEMiIL6FvU/Mjg/zWLLtqFYCq+HGrgRVQigm
         e1zJzySEmJ7pSb7vKwaNOzU+CG88I+Vm5N2F6Vmg60ITcOh6RaK2G52nuUAqhRk7QpWT
         jKGMiyN6PpnOOGPsPIukYvhMFkaarZQ4yeSa1wdJ1yDxyAA1MLvXSOCLVDnpBJN9yWq2
         UzM3uNt2YbG7Sa4i5E79iwTPccj9Z6xjuyIg1TF4ioqpdc5bEslAT2EgP+LR4fpOBfKS
         4KTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JyKLP13MA3we/vWXo7vrVA6xMNeRPMkMoZjirv2W5f8=;
        b=szwbNOW340Hfr+2PwizwZwucn4EhqXN3WvNetSHsWvd0EmQRJQMJwPZ7PfB7L6K/fc
         leaUW30hOyN/2hhKzTADZxtYIGim19JQv83Q8PAr1an7n2HQzzPC3XuM1+pUjGjjYsAy
         FJuH8g92nrM1FIEUnQ0Kh5KAFb6zim+A5+K25gziMflTrrSl/dxesGBYAgoBeY+pz3De
         L7LeEXZMIktE70JvEqKAZZW7sCTKiEtlRxGRyMfaUkZed+p9qx74L4OQOjJpQnFvYVFU
         J2oDZtxNJoKP267s7RQ8wfMeoUuqpxfWh+tbz4A5IneSwHX1TwTSVGHrCgd269UAVN4F
         uoEQ==
X-Gm-Message-State: AOAM5306NgY4u3ftBcAGZ10cYHR5FQTPM3PiHqdHMm/cJfryz5QiwJ17
        bCBZ4SmyKBzJm9a47rWhQEaYg2rMf7pjqg==
X-Google-Smtp-Source: ABdhPJxPuHCjth4EvPORtZ3tcp/As6OSbqLCTv4lhJm6iUiMx7p+8K7lcbf/Vp1AKm6A+CrjKnFUXQ==
X-Received: by 2002:a37:6fc6:: with SMTP id k189mr21800161qkc.289.1592947310034;
        Tue, 23 Jun 2020 14:21:50 -0700 (PDT)
Received: from DESKTOP-J6NUVB7.localdomain ([179.232.194.217])
        by smtp.gmail.com with ESMTPSA id b4sm1459665qka.133.2020.06.23.14.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 14:21:49 -0700 (PDT)
From:   =?UTF-8?q?Jo=C3=A3o=20H=2E=20Spies?= <jhlspies@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20H=2E=20Spies?= <jhlspies@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: ingenic: gcw0: Fix HP detection GPIO.
Date:   Tue, 23 Jun 2020 18:19:45 -0300
Message-Id: <20200623211945.823-1-jhlspies@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously marked as active high, but is in reality active low.

Cc: stable@vger.kernel.org
Fixes: b1bfdb660516 ("MIPS: ingenic: DTS: Update GCW0 support")
Signed-off-by: João H. Spies <jhlspies@gmail.com>
---
 arch/mips/boot/dts/ingenic/gcw0.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/gcw0.dts b/arch/mips/boot/dts/ingenic/gcw0.dts
index 8d22828787d8..bc72304a2440 100644
--- a/arch/mips/boot/dts/ingenic/gcw0.dts
+++ b/arch/mips/boot/dts/ingenic/gcw0.dts
@@ -92,7 +92,7 @@
 			"MIC1N", "Built-in Mic";
 		simple-audio-card,pin-switches = "Speaker", "Headphones";
 
-		simple-audio-card,hp-det-gpio = <&gpf 21 GPIO_ACTIVE_HIGH>;
+		simple-audio-card,hp-det-gpio = <&gpf 21 GPIO_ACTIVE_LOW>;
 		simple-audio-card,aux-devs = <&speaker_amp>, <&headphones_amp>;
 
 		simple-audio-card,bitclock-master = <&dai_codec>;
-- 
2.17.1


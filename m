Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22548242895
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 13:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgHLLYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 07:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgHLLYO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 07:24:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5356C06174A;
        Wed, 12 Aug 2020 04:24:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d22so877440pfn.5;
        Wed, 12 Aug 2020 04:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9+WajxCq7gTYxJQxz4BklwsXaVQmRwBfSGv+L76EXJk=;
        b=ecicS9VZv9HYbYw5uW+HOhpoCA9mG7Ds4jcUUcSnWo5LW+O4JdKS6cZm7EBb0sl8pZ
         fotKQKF8sYohP++PnzDYZLiwdW99f9JgWLtuwcMPRP8loDiqQquYoVgTNUcy3m/EN73h
         HB7hoLWLYYAluZcW3T7FbXZRorvMJ4A6TPaYvQLwa7pJixKtgE3ZKlvuBKBxiDfflLSw
         xP7uguGcCwWjxoVIawi9/zme1lugd3mOu4dvnmedoQeqJdrl/VpTTGouMerEKnd/mnpF
         v9Re5+eYIx+jYsF+RgjRgbzxzNQBp4tGvvuxLKgRbBD1ogY9CcfjQLgdjtFtOxQ1IsMv
         lKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=9+WajxCq7gTYxJQxz4BklwsXaVQmRwBfSGv+L76EXJk=;
        b=A8vMGlfEuK5B0IUmqN2eA2RircaxlZI2oH8Xekb5NUnP9vRJDRmg/yq5tEtn5cDde1
         X5oiX4IropSzodg0QPTeBRs1zNL27Ei0C4YtcXw5CUby/ZifUmv4GAlU5g/FQGluM3/Q
         YwUA7o7mh2ZLnNwb/BEtUtKOhDOBpgV2SHhqc4CGSfwFLF+mjRkMF/FG14di39cxr5ZR
         9wQmuS515CLf7TgvO+i6aN+6xRrrWr6vUNDUNjJPm5v+k4IhIGKIiG6YvpcPMQRyHRRm
         vfJdmHyBZbhYUzMWMfcakcAVpjsw4uuKgpFTex+bstWxbtdEnjBgAl4wW8t4Sispo9lw
         OaGw==
X-Gm-Message-State: AOAM5300gOHc+g86KdVab3D7PafMrboUA5tWR0hNxT6GhYn7ZvuuIlBP
        ZTCscuy6n/BavYeyeRuThZU=
X-Google-Smtp-Source: ABdhPJyAxGGCmZs1UUyztQFKQGC3+UREwAgvsOBRFVJ8aUZLNMAttG/s9j8yZKTMOkwbSiThNxWDgg==
X-Received: by 2002:aa7:8c56:: with SMTP id e22mr10200501pfd.238.1597231452333;
        Wed, 12 Aug 2020 04:24:12 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.19])
        by smtp.gmail.com with ESMTPSA id m19sm2081536pgd.21.2020.08.12.04.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 04:24:10 -0700 (PDT)
From:   Joel Stanley <joel@jms.id.au>
To:     Oskar Senft <osk@google.com>, Jeremy Kerr <jk@ozlabs.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] ARM: aspeed: g5: Do not set sirq polarity
Date:   Wed, 12 Aug 2020 20:54:00 +0930
Message-Id: <20200812112400.2406734-1-joel@jms.id.au>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A feature was added to the aspeed vuart driver to configure the vuart
interrupt (sirq) polarity according to the LPC/eSPI strapping register.

Systems that depend on a active low behaviour (sirq_polarity set to 0)
such as OpenPower boxes also use LPC, so this relationship does not
hold.

The property was added for a Tyan S7106 system which is not supported
in the kernel tree. Should this or other systems wish to use this
feature of the driver they should add it to the machine specific device
tree.

Fixes: c791fc76bc72 ("arm: dts: aspeed: Add vuart aspeed,sirq-polarity-sense...")
Cc: stable@vger.kernel.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 arch/arm/boot/dts/aspeed-g5.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-g5.dtsi b/arch/arm/boot/dts/aspeed-g5.dtsi
index 27e5c5cf7712..664630a0e084 100644
--- a/arch/arm/boot/dts/aspeed-g5.dtsi
+++ b/arch/arm/boot/dts/aspeed-g5.dtsi
@@ -410,7 +410,6 @@ vuart: serial@1e787000 {
 				interrupts = <8>;
 				clocks = <&syscon ASPEED_CLK_APB>;
 				no-loopback-test;
-				aspeed,sirq-polarity-sense = <&syscon 0x70 25>;
 				status = "disabled";
 			};
 
-- 
2.28.0


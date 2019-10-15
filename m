Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDCF6D6FCD
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 09:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbfJOG7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 02:59:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41989 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfJOG7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 02:59:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so11832296pff.9
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 23:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d6TuX5wbjT0cVL+CWwuFac6eFY+2DAq9db0NWeLvHfw=;
        b=Pye2eFODufy4FTc3Xuhtdnel9539e3atHEkUYgW5W90Gt+TPrWlJaLHjhn8B8ywWxY
         JoudPnOzfKiGz6r/GXUjxsc4y9rmrC8nFGkyt8fSr7TSs1mm4WMoH8rNZ0mldDmfBtk2
         U1SNxtyH+z30OFykMII7vnC5xK8AngQM6Dtw8G5BPgn45gK2tBi9zBLJH1Io0eoWDHZD
         qy8D4/WWO0Jwnx529wxnERHIqvwFUr21JjxqduVRUwPGrduJGGtSYPoXVgxyF0mmB2Ce
         fAw+5B5ywpYV68NUjSKvUhv3Gtx0ZCheLTTiffLXcmdB6dzRX5oaNEvD26RWP41nZxAE
         q2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d6TuX5wbjT0cVL+CWwuFac6eFY+2DAq9db0NWeLvHfw=;
        b=J6RWjkFLoyYrO0I2KJ0vHkO92Z6JDqg+8g0eAxSeD1kPYV4zKolxIE7jkTxcVDZ2Zo
         6HP3Oaj3kUwcfCT/pSurXU6FwPCEY9BSs+BiWqYxsMVkPJKJoHemf7H7v8vFj3SfzbYS
         Sg50XDAwauLq/W6Vo/Q2yLDV7MJK5/X/AReeeN6r50kB9iOWWzqUfYKTvJWk0ih8CqW8
         W9dGTAviCOXZzdSb6tdSn4Fn30tuVCzbch6/zOuk/xVry4vMFXUR9d84kIQVw5Pp8uHO
         dn16a2D9+ZH9QGQfbFtZP+gXSsfqmUGnhNCwlxTabqBesSW2pf7l5YPGs7xQ1TBfYOIz
         akSA==
X-Gm-Message-State: APjAAAWfTKCpTuGgAQsVSWHFMo3dMbfxEjDHOEA4cMfKU7/R1DxkZ9c0
        1TZTenTPo3/adLAY6Is+CTFLISrPNbI=
X-Google-Smtp-Source: APXvYqy6bs2VA4ZtJFgvxKRN0L+Ft8psiktp6GA6jTulW2YhCe3WNJiVPW4r4+fnGDmoR0/4lfTFLw==
X-Received: by 2002:a62:6247:: with SMTP id w68mr37823007pfb.11.1571122782444;
        Mon, 14 Oct 2019 23:59:42 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id i16sm17952646pfa.184.2019.10.14.23.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:59:40 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 3/4] arm64: dts: ti: k3-am65-main: Fix gic-its node unit-address
Date:   Tue, 15 Oct 2019 00:59:36 -0600
Message-Id: <20191015065937.23169-3-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015065937.23169-1-mathieu.poirier@linaro.org>
References: <20191015065937.23169-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

commit 389ce1a7c5279ebfb682fab220b4021b2bd49c8b upstream

The gic-its node unit-address has an additional zero compared
to the actual reg value. Fix it.

Fixes: ea47eed33a3f ("arm64: dts: ti: Add Support for AM654 SoC")
Reported-by: Robert Tivy <rtivy@ti.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Cc: stable <stable@vger.kernel.org> # 4.19
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 2409344df4fa..e23c5762355d 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -21,7 +21,7 @@
 		 */
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
 
-		gic_its: gic-its@18200000 {
+		gic_its: gic-its@1820000 {
 			compatible = "arm,gic-v3-its";
 			reg = <0x01820000 0x10000>;
 			msi-controller;
-- 
2.17.1


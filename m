Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCE2ED499
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 17:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbhAGQoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 11:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbhAGQoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 11:44:13 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C3C0612F6;
        Thu,  7 Jan 2021 08:43:32 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id b64so5926871qkc.12;
        Thu, 07 Jan 2021 08:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jsj8ODPUVGLdmQ9ZhYyriA2vHFuowLpKi9rT1V6rJXE=;
        b=Zc3h1rsXADb4XDmNTyj969AJjTwtBm3pimlrn95jHQo3MVe93eyBwfzqAPn5tgsaFC
         82LYnFpJM1vfGlQdPRi+WSZEI467Qpj9YrkGGep6WlhBBxPum2wNO8tfjvlMzMlL6R0e
         xaY06a5pxJiEjlKKXFrbmZ/bdEhKPLZh0NBrdTslaMlyFPVHAseCw5OrP/979CWwQVWm
         S+8cuJqq/uqKJdtd+zG1c1wYJ51qSj6pKmv7nCysEZ2pefSn1zfalzi6x/HCAEqy43Zx
         Ii3D/1SClFp9KQiXA4ED4A2Ss5caAh8Gw/2skjXzdFunHtYrYbrdNwnY2XkTNDa+WZlo
         rpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jsj8ODPUVGLdmQ9ZhYyriA2vHFuowLpKi9rT1V6rJXE=;
        b=pJHEe1ffJt9MsdgU5wjc9DoAUqI4DHuw4MP/Rz7EBuoBO1cAeovrLOHAKb+AgNMPr5
         mnA05CeVTiELZaSAh/s7nokPOcAWRBAHn+j0I0/Q9QMFhXnlO7SRYK7e01PnZ2TYIuyk
         09r3hkx0LHnx+Yy3YSrHtGHYRzcl7F4OFpwAH7fEj6rLC4TextkPmo1HKQUdZT+OqLWH
         Csb+GQJLxI/fRfJBVWO09l5212dcd043ymF8XosuAeNb++R5s9BUQmXIEwKPWV7oT31V
         myaOP5F09ZLi0dfbQomcbu1g8y8hTEN1hqgCXW3YiDhRKtG/YAcrVeMwaeWQXs7PbIR8
         RwxA==
X-Gm-Message-State: AOAM530G6KOEvEaGg14vOPcGgLiwidJAVuokKYOoOG86v5vZiqGYkdDG
        ttNlhhq92sHmRHKdkbG+InFMtHLNDYAbH8Fk
X-Google-Smtp-Source: ABdhPJzG6u1GAtMiUox4ef0ujdbezDLwCo/L3lLPChbhrGuLb+olQMOx5+4MheVKN7g5vh9ftbNIEg==
X-Received: by 2002:a05:620a:147a:: with SMTP id j26mr9749198qkl.190.1610037811796;
        Thu, 07 Jan 2021 08:43:31 -0800 (PST)
Received: from rockpro64.hsd1.md.comcast.net ([2601:153:900:7730::20])
        by smtp.gmail.com with ESMTPSA id u26sm3391460qke.57.2021.01.07.08.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:43:31 -0800 (PST)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        stable@vger.kernel.org, Matt Merhar <mattmerhar@protonmail.com>
Subject: [PATCH v2] ARM: tegra: ouya: Fix eMMC on specific bootloaders
Date:   Thu,  7 Jan 2021 16:43:13 +0000
Message-Id: <20210107164313.1339428-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ouya fails to detect the eMMC module when booted via certain bootloaders.
Fastboot and hard-kexec bootloaders fail while u-boot does not. It was
discovered that the issue manifests if the sdmmc4 alternate configuration
clock pin is input disabled.

Ouya uses sdmmc4 in the primary pin configuration. It is unknown why this
occurs, though it is likely related to other eMMC limitations experienced
on Ouya.

For now, fix it by enabling input on cam_mclk_pcc0.

Cc: stable@vger.kernel.org # 5.10+
Fixes: d7195ac5c9c5 ("ARM: tegra: Add device-tree for Ouya")
Reported-by: Matt Merhar <mattmerhar@protonmail.com>
Tested-by: Matt Merhar <mattmerhar@protonmail.com>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
Changes v2:
-Added stable tag.
-Improved commit message.

 arch/arm/boot/dts/tegra30-ouya.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-ouya.dts b/arch/arm/boot/dts/tegra30-ouya.dts
index 74da1360d297..0368b3b816ef 100644
--- a/arch/arm/boot/dts/tegra30-ouya.dts
+++ b/arch/arm/boot/dts/tegra30-ouya.dts
@@ -4352,8 +4352,8 @@ cam_mclk_pcc0 {
 		nvidia,pins = "cam_mclk_pcc0";
 		nvidia,function = "vi_alt3";
 		nvidia,pull = <TEGRA_PIN_PULL_NONE>;
-		nvidia,tristate = <TEGRA_PIN_ENABLE>;
-		nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+		nvidia,tristate = <TEGRA_PIN_DISABLE>;
+		nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 	};
 	pcc1 {
 		nvidia,pins = "pcc1";
-- 
2.25.1


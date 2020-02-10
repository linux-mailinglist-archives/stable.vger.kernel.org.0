Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1B7156F72
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 07:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgBJGUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 01:20:06 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39632 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgBJGUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 01:20:06 -0500
Received: by mail-lj1-f195.google.com with SMTP id o15so5731562ljg.6
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 22:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2PN4vJEg9KaKQ1Gg0Q/hD/V0UfUMXoLIlBrPYupbPdg=;
        b=Pkz2Dup+1MxEA03fiNJWvDhbdAKAgUhbj0wMjaZ/ao4m8JqxZLPmmP6sdVkgkUXhCM
         c1mzkQMQeECQUO1q9CcVIc9ATClUe7wV1K/CkAel46yn7/LwC4foe3JDdauxpQxP79RG
         TAP2Xgjx1IGPVVic+p2wM4vxiAWYmoGs5eLXEkoXdQBJ/ao4kKRYyfyPqUaEKysPq1hs
         VUHAV8Xz5sbwWdmdy5oaHCBNjS599N3KjSXEZwxGNCpijUlcFa8CIpeYAjQvy6VabKD1
         VAa78k04X/6zfsO+51LFSH4c0r+1mt3GkJSXLB5Z2JaGAmAdI9c3O+/uF1hfMa5fI87y
         AJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2PN4vJEg9KaKQ1Gg0Q/hD/V0UfUMXoLIlBrPYupbPdg=;
        b=H+4NsE1Uet9QPcV0kvxAE5XwB3HLpFHMIzPqQK5vVM0iTOuEFznx4JTqzRRj6pKLYV
         3rjMqbDyEKMFTYy9RP17LayIRkGgnMkmeDNY0JFjswCTV845x8Qjetv6Sc9ct089C6Ui
         gD4C4a6XdoFvqFCR/THhBzMQG3jSd6dRC0AzTFSVgnBrZllUnMc5fGwdDxtIhZyr1jUp
         HoWTJFntALwlZhtJR3Qa9nxNcdICldufZyfDjdUE1GcViAL3YVVRJXZRCBiwbYj4ZHhv
         VoBw1WGldHV95ytZfKrAVgv1xXp+NnPocG1Hsb7UktC/9KJ34BhpAGpA6QLjFnShuV5y
         7MVg==
X-Gm-Message-State: APjAAAXiEKNb1OcUCwFu3mPiM+H7KiOzwWtohOXa6GK4fpSM0W9Mb5hL
        XziXbHxhLiRh2baFe7DW1CcmE1P+Ie3AHJgH0xjO/A==
X-Google-Smtp-Source: APXvYqzO25uDTXNv28ZJ16962I8I5JrXjq/hX9F0yWnYKUG8R9bAmJrIxN0tL0csFV5haJw6Vzd+Fi+aTcW3Oxl4JRc=
X-Received: by 2002:a2e:e12:: with SMTP id 18mr7059758ljo.123.1581315603028;
 Sun, 09 Feb 2020 22:20:03 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 10 Feb 2020 11:49:52 +0530
Message-ID: <CA+G9fYt1d+kyNkqzaSMO2D9X4EbmU6dq+Qaw2VC_2B7xxdb3Jg@mail.gmail.com>
Subject: clk: tegra: Mark fuse clock as critical - build failed on 4.4-stable tree
To:     Stephen Warren <swarren@nvidia.com>, treding@nvidia.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch caused build failed on stable rc 4.4 branch for arm64
Juno-r2 device and arm beagleboard x15 device

commit bf83b96f87ae2abb1e535306ea53608e8de5dfbb upstream.

For a little over a year, U-Boot on Tegra124 has configured the flow
controller to perform automatic RAM re-repair on off->on power
transitions of the CPU rail[1]. This is mandatory for correct operation
of Tegra124. However, RAM re-repair relies on certain clocks, which the
kernel must enable and leave running. The fuse clock is one of those
clocks. Mark this clock as critical so that LP1 power mode (system
suspend) operates correctly.

[1] 3cc7942a4ae5 ARM: tegra: implement RAM repair

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/tegra/clk-tegra-periph.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

(limited to 'drivers/clk/tegra/clk-tegra-periph.c')

diff --git a/drivers/clk/tegra/clk-tegra-periph.c
b/drivers/clk/tegra/clk-tegra-periph.c
index cb6ab83..eb04d99 100644
--- a/drivers/clk/tegra/clk-tegra-periph.c
+++ b/drivers/clk/tegra/clk-tegra-periph.c
@@ -516,7 +516,11 @@ static struct tegra_periph_init_data gate_clks[] = {
  GATE("vcp", "clk_m", 29, 0, tegra_clk_vcp, 0),
  GATE("apbdma", "clk_m", 34, 0, tegra_clk_apbdma, 0),
  GATE("kbc", "clk_32k", 36, TEGRA_PERIPH_ON_APB |
TEGRA_PERIPH_NO_RESET, tegra_clk_kbc, 0),
- GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, 0),
+ /*
+ * Critical for RAM re-repair operation, which must occur on resume
+ * from LP1 system suspend and as part of CCPLEX cluster switching.
+ */
+ GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse,
CLK_IS_CRITICAL),
  GATE("fuse_burn", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse_burn, 0),
  GATE("kfuse", "clk_m", 40, TEGRA_PERIPH_ON_APB, tegra_clk_kfuse, 0),
  GATE("apbif", "clk_m", 107, TEGRA_PERIPH_ON_APB, tegra_clk_apbif, 0),

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.4/DISTRO=lkft,MACHINE=juno,label=docker-lkft/742/console
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.4/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/742/console

-- 
Linaro LKFT
https://lkft.linaro.org

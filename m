Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71DF189F94
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCRPZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:25:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52866 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgCRPZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 11:25:20 -0400
Received: by mail-wm1-f66.google.com with SMTP id 11so3899749wmo.2
        for <stable@vger.kernel.org>; Wed, 18 Mar 2020 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=nab/6yTyXyAvQS5wvzCsXOFKPhMnWoE9hRGSnfG/O/U=;
        b=oDZH2AI1geJDKc2hNLj03MFjQNBoAC965fStJ+rKJG+IX/+5cu4NeJusNWhq7cMSr2
         AkgSVoRdoKFIp4bOJBbWe8P9a8C8KnKetzn5nJjpq9mu4mvkQJtEKPGHSox/4Knjnxh6
         nKabomFkcAe2n7ALhgF2Qgx4VaCz4e+yjHaNrBe9jUso5okE/4f4LRMRtI+lmeFOR5sQ
         23y8whNXTerFt/xeS1rMD64zs1olpvYlPazR5b1hgqrvLN9tSa1Ofw2XkzFJi0Hu7c+V
         +iDhNmnA8/k6axU9IyIIGiXj16GO7VQZwc/3B1dLARSytOvLOcYTDvqK4NRGGRbcmUJd
         PmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nab/6yTyXyAvQS5wvzCsXOFKPhMnWoE9hRGSnfG/O/U=;
        b=MISk6wHi7aQGJ0OmUYQyHIAiA8moDqt0K0wf0wSjpOBHf9CgLpeZq8ixJZYzX49IKk
         0omsV/fyjBI8eH6vS99NnU9tCJIde9rX7DPHLYXi7v3TWoIMxtrjO6Ove9LmTPh5aDWE
         dUE3SedQKQUHz2qhUR4cdYXKw5bc3QIvQmvEDqVfuxsfMS7CTP0ABlfIeaR0vcx76inm
         /kOIBqVJICpXCBSqwR6Z520eZwtU62rpLvpL/dpXYATDF5wz4NCc609ERhR2XRZXKHC7
         6XOgAJtQU5Nu0z4LXLKqYgm5Ja+qDbYIe83fzC25fNC5GWl9VQRNgcn7dprwsrF/OR2R
         bgzw==
X-Gm-Message-State: ANhLgQ1mK/Kj69nj0ppp+r/4ejzI2gpuzGPUqpOevhGoX4RSSZ3nEpKs
        4BGsZ0bs7E9otXgCqvtQbJabGw==
X-Google-Smtp-Source: ADFU+vtG5bw8E90hbIOPGoH28YXVsfwUmdGhXR28j/CWC/7TvD0xA+OrQfwWjbc0BJ9lY7yLu4sfOA==
X-Received: by 2002:a1c:9e97:: with SMTP id h145mr5673353wme.36.1584545118593;
        Wed, 18 Mar 2020 08:25:18 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id d21sm9785085wrb.51.2020.03.18.08.25.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Mar 2020 08:25:17 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     avienamo@nvidia.com, jonathanh@nvidia.com,
        thierry.reding@gmail.com, treding@nvidia.com
Cc:     linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] soc/tegra: pmc: should select GENERIC_PINCONF
Date:   Wed, 18 Mar 2020 15:25:08 +0000
Message-Id: <1584545108-20111-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I have hit the following build error:
armv7a-hardfloat-linux-gnueabi-ld: drivers/soc/tegra/pmc.o: in function `pinconf_generic_dt_node_to_map_pin':
pmc.c:(.text+0x500): undefined reference to `pinconf_generic_dt_node_to_map'
armv7a-hardfloat-linux-gnueabi-ld: drivers/soc/tegra/pmc.o:(.rodata+0x1f88): undefined reference to `pinconf_generic_dt_free_map'

So SOC_TEGRA_PMC should select GENERIC_PINCONF

Fixes: 4a37f11c8f57 ("soc/tegra: pmc: Implement pad configuration via pinctrl")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/soc/tegra/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/tegra/Kconfig b/drivers/soc/tegra/Kconfig
index 3693532949b8..6bc603d0b9d9 100644
--- a/drivers/soc/tegra/Kconfig
+++ b/drivers/soc/tegra/Kconfig
@@ -133,6 +133,7 @@ config SOC_TEGRA_FLOWCTRL
 
 config SOC_TEGRA_PMC
 	bool
+	select GENERIC_PINCONF
 
 config SOC_TEGRA_POWERGATE_BPMP
 	def_bool y
-- 
2.24.1


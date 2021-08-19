Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D963F1521
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbhHSIZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 04:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbhHSIZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 04:25:03 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC114C061756
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 01:24:27 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id l18so2570769lji.12
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 01:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XAahqRt3aqb5MLsAR4aGo2YrpQJcocQPKcdesYZ7FU=;
        b=RcAvziP+WN1UOMn0gnMYQuuLjCzZ64hq+bqIFy7PKLgj0j7FlnklStb/5VP+8K392u
         5vxjtPevFVn2jjF0xsRBGpiYWWEJGdFfrSWwn3rtCX6mOtVk6Z8m0hMCZIA0C7LJ1XoL
         QF4OmiGaRV9vagjPHFEHYD0D1FAdF0rDjQvQA6dmGuk8ikxPvCtbABlFpZ/pPOOeMNyb
         ImvwxAK+0OZBp9mjcuF6SOIjgU1Wi0C2n9/EstWi4HFnm81Is0cjDHp4r6sFdqyjPLX3
         g20uMsfhz9USgQRl7RiDY11PnjllXnpuUD2irc4QjgWq1BUnywDk8PKQ8K1iVbQiI0AH
         2+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XAahqRt3aqb5MLsAR4aGo2YrpQJcocQPKcdesYZ7FU=;
        b=PF8v5bspTBZopflBdOCc8WEprJ0evh6Fdq8ULOV53xKTfmeZzAIbSS1Tr8wMm2GLmh
         rYCpiwoQHbH328zAA5OmDVTGn0FxtCgxdNJt8mgRob04bSVemZGLcVo4FatXVcZRV2ec
         ftHouV2LaBmwnwV/VwsFxx8RnD2Ut5dvOqNxU6sHs6sQlpzZzE3VwlfP09tFyt2Cagn/
         nD4khuFaI6KcZlxBAKXmAMhliGFEDiw4BmCE+V1ssQ/ZmovYYjge03g92blYxTQRG7+S
         Uo9if9OqfQ8J5PFCOh26A1+xRwrpHbTy7zCR2WVsuKrX2x9Y70asaBEJ3iVBelv6brpv
         XF/g==
X-Gm-Message-State: AOAM532NWtm8Bx7UBziBqdvgDU0CN8yL80dGwrX1V8MhjQ8wKSseYUO7
        JqkaX8eWfYuocOZAwjK8JLrQfA==
X-Google-Smtp-Source: ABdhPJyRbn332NGgU8QZSuxAjb3e9exmd8DFOkcZswqNNaTkzwNrFUsgkx4du82jsWbVD/9EFxxnqw==
X-Received: by 2002:a2e:a44f:: with SMTP id v15mr11142228ljn.301.1629361466060;
        Thu, 19 Aug 2021 01:24:26 -0700 (PDT)
Received: from lmajczak1-l.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id f16sm198210ljq.58.2021.08.19.01.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 01:24:25 -0700 (PDT)
From:   Lukasz Majczak <lma@semihalf.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     upstream@semihalf.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        Lukasz Majczak <lma@semihalf.com>, stable@vger.kernel.org
Subject: [PATCH v2] ASoC: Intel: Fix platform ID matching for kbl_da7219_max98373
Date:   Thu, 19 Aug 2021 10:24:14 +0200
Message-Id: <20210819082414.39497-1-lma@semihalf.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sparse warnings triggered truncating the IDs of some platform device
tables. Unfortunately kbl_da7219_max98373 was also truncated.
This patch is reverting the original ID.
Tested on Atlas chromebook.

Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
Cc: <stable@vger.kernel.org> # 5.4+
Tested-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Suggested-by: Cezary Rojewski <cezary.rojewski@intel.com>
---
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
index 741bf2f9e081..8cab91a00b1a 100644
--- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
@@ -113,7 +113,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_mx98373",
+		.drv_name = "kbl_da7219_max98373",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98373_codecs,
-- 
2.33.0.rc2.250.ged5fa647cd-goog


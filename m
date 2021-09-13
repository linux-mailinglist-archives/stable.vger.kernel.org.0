Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CD3408FA2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbhIMNpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242989AbhIMNmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B05610CB;
        Mon, 13 Sep 2021 13:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539819;
        bh=JnOYUCM/odPvFwMJ+pBKcmqXkWsfvgjZzfpdbCAT2NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VprX1tWV4JhljgBQ5GrA8rkNdLs8234Ddbxr4At3Obc0w20wp1oMJDHTNQpuOs+ve
         C5KUipS/eY6iIui+wLfG5X5tbViNt2h5ius2j+L+wVt6pkMEI1whsKLwLiNT/xmzHF
         rlGeKR650zOxZS/p+GWmp2Cvx8aQQmHSuqCsBVMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        Matt Davis <mattedavis@google.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/236] ASoC: Intel: Fix platform ID matching
Date:   Mon, 13 Sep 2021 15:14:05 +0200
Message-Id: <20210913131105.122905815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit f4eeaed04e861b95f1f2c911263f2fcaa959c078 ]

Sparse warnings triggered truncating the IDs of some platform device
tables. Unfortunately some of the IDs in the match tables were missed
which breaks audio. The KBL change has been verified to fix audio, the
CML change was not tested as it was found through grepping the broken
changes and found to match the same situation in anticipation that it
should also be fixed.

Fixes: 94efd726b947 ("ASoC: Intel: kbl_da7219_max98357a: shrink platform_id below 20 characters")
Fixes: 24e46fb811e9 ("ASoC: Intel: bxt_da7219_max98357a: shrink platform_id below 20 characters")
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Tested-by: Matt Davis <mattedavis@google.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210809213544.1682444-1-cujomalainey@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-cml-match.c | 2 +-
 sound/soc/intel/common/soc-acpi-intel-kbl-match.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-cml-match.c b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
index 26dde88bb227..9b85811ffd51 100644
--- a/sound/soc/intel/common/soc-acpi-intel-cml-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-cml-match.c
@@ -62,7 +62,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_cml_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "cml_da7219_max98357a",
+		.drv_name = "cml_da7219_mx98357a",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &max98390_spk_codecs,
 		.sof_fw_filename = "sof-cml.ri",
diff --git a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
index 4ed1349affc4..20f2132a9cd6 100644
--- a/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-kbl-match.c
@@ -87,7 +87,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_kbl_machines[] = {
 	},
 	{
 		.id = "DLGS7219",
-		.drv_name = "kbl_da7219_max98357a",
+		.drv_name = "kbl_da7219_mx98357a",
 		.fw_filename = "intel/dsp_fw_kbl.bin",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &kbl_7219_98357_codecs,
-- 
2.30.2




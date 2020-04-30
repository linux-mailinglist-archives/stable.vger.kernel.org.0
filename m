Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8704D1BFD8C
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgD3ONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbgD3Nuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF0F20870;
        Thu, 30 Apr 2020 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254655;
        bh=leLlCGybufOOpVhMiAXOfQofFaZLZ2JQZlg6bMaHjAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbxAfXSxalQJS+kTCn9b9yyHxBOWtXSRHmghgR/GXkujto9sHgBQttAnSUg2v2z2K
         M+pTSDFpy80Du/jIZasrZoLWpbiI5rliSBDqvLxznALQOsO6+eFRNWRqWFdFqedHZJ
         4+eKvIScXLM8vSHTEgHlxShSzhxT+ddiPYOBMgF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 09/79] ASoC: topology: Check return value of soc_tplg_*_create
Date:   Thu, 30 Apr 2020 09:49:33 -0400
Message-Id: <20200430135043.19851-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 2ae548f30d7f6973388fc3769bb3c2f6fd13652b ]

Functions soc_tplg_denum_create, soc_tplg_dmixer_create,
soc_tplg_dbytes_create can fail, so their return values should be
checked and error should be propagated.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200327204729.397-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 5d974a36cdc92..c86c3ea533f68 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1124,6 +1124,7 @@ static int soc_tplg_kcontrol_elems_load(struct soc_tplg *tplg,
 	struct snd_soc_tplg_hdr *hdr)
 {
 	struct snd_soc_tplg_ctl_hdr *control_hdr;
+	int ret;
 	int i;
 
 	if (tplg->pass != SOC_TPLG_PASS_MIXER) {
@@ -1152,25 +1153,30 @@ static int soc_tplg_kcontrol_elems_load(struct soc_tplg *tplg,
 		case SND_SOC_TPLG_CTL_RANGE:
 		case SND_SOC_TPLG_DAPM_CTL_VOLSW:
 		case SND_SOC_TPLG_DAPM_CTL_PIN:
-			soc_tplg_dmixer_create(tplg, 1,
-					       le32_to_cpu(hdr->payload_size));
+			ret = soc_tplg_dmixer_create(tplg, 1,
+					le32_to_cpu(hdr->payload_size));
 			break;
 		case SND_SOC_TPLG_CTL_ENUM:
 		case SND_SOC_TPLG_CTL_ENUM_VALUE:
 		case SND_SOC_TPLG_DAPM_CTL_ENUM_DOUBLE:
 		case SND_SOC_TPLG_DAPM_CTL_ENUM_VIRT:
 		case SND_SOC_TPLG_DAPM_CTL_ENUM_VALUE:
-			soc_tplg_denum_create(tplg, 1,
-					      le32_to_cpu(hdr->payload_size));
+			ret = soc_tplg_denum_create(tplg, 1,
+					le32_to_cpu(hdr->payload_size));
 			break;
 		case SND_SOC_TPLG_CTL_BYTES:
-			soc_tplg_dbytes_create(tplg, 1,
-					       le32_to_cpu(hdr->payload_size));
+			ret = soc_tplg_dbytes_create(tplg, 1,
+					le32_to_cpu(hdr->payload_size));
 			break;
 		default:
 			soc_bind_err(tplg, control_hdr, i);
 			return -EINVAL;
 		}
+		if (ret < 0) {
+			dev_err(tplg->dev, "ASoC: invalid control\n");
+			return ret;
+		}
+
 	}
 
 	return 0;
-- 
2.20.1


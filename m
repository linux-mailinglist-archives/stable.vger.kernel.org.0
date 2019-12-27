Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1FF12B870
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfL0RmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbfL0RmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BB1420CC7;
        Fri, 27 Dec 2019 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468532;
        bh=FEufkkPCT+mRnvVJNE8hRSNOHE541zr3+4MMIWro1SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zn+8tySc5uTbgZW0F7knyeMBS5fi1MAeI6iPK0mIfdHQz/1eTcUIw4jqbcrMLvGo9
         JmxKAXloq6O3OV0k78X57titYbUAeS4S+V3ZdzEFLabM1fr6gvxj73IK/97x1w7Kah
         gM+hNxzoIvvRLRRYCsRRQB+cb1k3DKEfoTLBsUxI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karol Trzcinski <karolx.trzcinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 062/187] ASoC: SOF: loader: snd_sof_fw_parse_ext_data log warning on unknown header
Date:   Fri, 27 Dec 2019 12:38:50 -0500
Message-Id: <20191227174055.4923-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Trzcinski <karolx.trzcinski@linux.intel.com>

[ Upstream commit 8edc95667646a75f0fc97e08ecb180581fdff300 ]

Added warning log when found some unknown FW boot ext header,
to improve debuggability.

Signed-off-by: Karol Trzcinski <karolx.trzcinski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191210004854.16845-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index 9a9a381a908d..a041adf0669d 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -66,6 +66,8 @@ int snd_sof_fw_parse_ext_data(struct snd_sof_dev *sdev, u32 bar, u32 offset)
 			ret = get_ext_windows(sdev, ext_hdr);
 			break;
 		default:
+			dev_warn(sdev->dev, "warning: unknown ext header type %d size 0x%x\n",
+				 ext_hdr->type, ext_hdr->hdr.size);
 			break;
 		}
 
-- 
2.20.1


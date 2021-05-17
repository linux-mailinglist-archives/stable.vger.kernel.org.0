Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FAD382F0B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhEQOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238579AbhEQOLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB0C5613BE;
        Mon, 17 May 2021 14:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260454;
        bh=IT+5WeIpLY9wMHs/s4Kw3Wm0X2t8cPHtpBTEP+qGz78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+IyM6WidhUJrVQo+mPgtxSV0t5AEM+W71qq97ixCsPy2Xc+vjH4mIC55SVZ46C0Y
         xRK1+vo4FA3+/CTVN2nIt+zEaJsNUNGaHXQN9OpY7aTJK7DztNDf/imdO5hd+MATEj
         o3uvUmxEozYQp2L3K9Gym0Ncq04wr+5V9owjEysQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 088/363] ASoC: Intel: sof_sdw: add quirk for new ADL-P Rvp
Date:   Mon, 17 May 2021 15:59:14 +0200
Message-Id: <20210517140305.573122589@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>

[ Upstream commit d25bbe80485f8bcbbeb91a2a6cd8798c124b27b7 ]

Add quirks for jack detection, rt711 DAI and DMIC

Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210415175013.192862-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 8adce6417b02..ecd3f90f4bbe 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -187,6 +187,17 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_FOUR_SPK),
 	},
+	/* AlderLake devices */
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alder Lake Client Platform"),
+		},
+		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
+					SOF_SDW_TGL_HDMI |
+					SOF_SDW_PCH_DMIC),
+	},
 	{}
 };
 
-- 
2.30.2




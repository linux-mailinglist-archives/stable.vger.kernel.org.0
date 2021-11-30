Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ED2463712
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242455AbhK3Ouy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:50:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44740 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242423AbhK3Ouw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:50:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFC68B81A22;
        Tue, 30 Nov 2021 14:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0DCC53FC1;
        Tue, 30 Nov 2021 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283650;
        bh=y95rrPScOeNkOYR7yvkD1RXg59JxHr3Ihjwo6aV5tvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYl9P4Wl0EOF60SobxkIh9VzuHCPrixojk6kBs8G8nkZi4k4eeTVDpCymbiD2CPRe
         XAdL5S0Yp8gVGFTmTtmnkc+yI1sfQ8vw7ULoASmaWaqDhQ1xz9mZCKGJnHpsae3jKx
         RH4WEC7MmW2gsXK7edgU+LIUKtO4FaynLn39Aivot8K6UKGwJnfmHKeLw9FJzsggI3
         5zfoTxCJl2d8gUe+dJxoMub37I7Fh8qpwEzgEEwtRLrt0lrwaSQqLeMMzxcV2zAx+j
         AHe0/ds+JpzLnCGwtC7ituHC9TdrW+BAk1FiDOp+lw5NYe3nOc3uYMUQ1+uB46q3qO
         dTxc0xYw+u9Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gongjun Song <gongjun.song@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cezary.rojewski@intel.com,
        liam.r.girdwood@linux.intel.com, yang.jie@linux.intel.com,
        perex@perex.cz, tiwai@suse.com, kai.vehmanen@linux.intel.com,
        libin.yang@intel.com, vamshi.krishna.gopal@intel.com,
        yong.zhi@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 06/68] ASoC: Intel: sof_sdw: Add support for SKU 0B13 product
Date:   Tue, 30 Nov 2021 09:46:02 -0500
Message-Id: <20211130144707.944580-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gongjun Song <gongjun.song@intel.com>

[ Upstream commit 6448d0596e48dbc16a910f04ffc248c3f3c0a65c ]

This product supports SoundWire capture from local microphones
and one SoundWire amplifier(no headset codec).

Signed-off-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211105022646.26305-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index d0bea028b9b76..25cdd61f09a80 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -288,6 +288,15 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2 |
 					SOF_SDW_FOUR_SPK),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0B13"),
+		},
+		/* No Jack */
+		.driver_data = (void *)SOF_SDW_TGL_HDMI,
+	},
 	{}
 };
 
-- 
2.33.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE2E12B86F
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfL0Rzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfL0RmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6877C24650;
        Fri, 27 Dec 2019 17:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468533;
        bh=pKlEvZStrRWwiobdGwZb/2fTuQEcO/9zO6CNnj/hiDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDAzCHXIkPD9AUOj0BnW7WHAI6fSyhz0T0v0zRoWnY32Bk5M/qSBRvwGFUEFuUYHK
         YG5wdxNAnMujwppG6FTO8dz5X3SP5cyUnb8yy0BO+j3nFzo+aI40HKvwta2HQG0Wrg
         n4c161equmuKy/YGNSRHElrXf2afIbyw3nYpbxeY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Curtis Malainey <cujomalainey@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 063/187] ASoC: SOF: Intel: split cht and byt debug window sizes
Date:   Fri, 27 Dec 2019 12:38:51 -0500
Message-Id: <20191227174055.4923-63-sashal@kernel.org>
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

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit f84337c3fb8ff4d533ccbed0d2db4e8587d0ff58 ]

Turns out SSP 3-5 are only available on cht, to avoid dumping on
undefined registers let's split the definition.

Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191210004854.16845-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/byt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/byt.c b/sound/soc/sof/intel/byt.c
index a1e514f71739..41008c974ac6 100644
--- a/sound/soc/sof/intel/byt.c
+++ b/sound/soc/sof/intel/byt.c
@@ -24,7 +24,8 @@
 #define DRAM_OFFSET		0x100000
 #define DRAM_SIZE		(160 * 1024)
 #define SHIM_OFFSET		0x140000
-#define SHIM_SIZE		0x100
+#define SHIM_SIZE_BYT		0x100
+#define SHIM_SIZE_CHT		0x118
 #define MBOX_OFFSET		0x144000
 #define MBOX_SIZE		0x1000
 #define EXCEPT_OFFSET		0x800
@@ -75,7 +76,7 @@ static const struct snd_sof_debugfs_map byt_debugfs[] = {
 	 SOF_DEBUGFS_ACCESS_D0_ONLY},
 	{"dram", BYT_DSP_BAR, DRAM_OFFSET, DRAM_SIZE,
 	 SOF_DEBUGFS_ACCESS_D0_ONLY},
-	{"shim", BYT_DSP_BAR, SHIM_OFFSET, SHIM_SIZE,
+	{"shim", BYT_DSP_BAR, SHIM_OFFSET, SHIM_SIZE_BYT,
 	 SOF_DEBUGFS_ACCESS_ALWAYS},
 };
 
@@ -102,7 +103,7 @@ static const struct snd_sof_debugfs_map cht_debugfs[] = {
 	 SOF_DEBUGFS_ACCESS_D0_ONLY},
 	{"dram", BYT_DSP_BAR, DRAM_OFFSET, DRAM_SIZE,
 	 SOF_DEBUGFS_ACCESS_D0_ONLY},
-	{"shim", BYT_DSP_BAR, SHIM_OFFSET, SHIM_SIZE,
+	{"shim", BYT_DSP_BAR, SHIM_OFFSET, SHIM_SIZE_CHT,
 	 SOF_DEBUGFS_ACCESS_ALWAYS},
 };
 
-- 
2.20.1


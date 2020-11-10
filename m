Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A222ACE45
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731803AbgKJEIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:08:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731341AbgKJDxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBD2020870;
        Tue, 10 Nov 2020 03:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980405;
        bh=Rl2FmOKz3FhvTMwiGKfppdkVk2uGslV89dplTpWMBbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPEBMhWEoez8HYeHPrKsTajmEGoYiwtdAnWHA6C9I5q8bGwIVYJl3uW8DL4g7SeEF
         OJgCiNWhSNZcrSNDCWlDctvohqTWsqIy+2ehrbkJdDe1NjG6sshgUAxL+DrfomuTsb
         jLNuVxyUKvIjaf+bTmTDD1SYMzbXXPS5by3L4Kvs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.9 04/55] ASoC: SOF: loader: handle all SOF_IPC_EXT types
Date:   Mon,  9 Nov 2020 22:52:27 -0500
Message-Id: <20201110035318.423757-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 6e5329c6e6032cd997400b43b8299f607a61883e ]

Do not emit a warning for extended firmware header fields that are
not used by kernel. This creates unnecessary noise to kernel logs like:

sof-audio-pci 0000:00:1f.3: warning: unknown ext header type 3 size 0x1c
sof-audio-pci 0000:00:1f.3: warning: unknown ext header type 4 size 0x10

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20201021182419.1160391-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/loader.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index b94fa5f5d4808..c90c3f3a3b3ee 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -118,6 +118,11 @@ int snd_sof_fw_parse_ext_data(struct snd_sof_dev *sdev, u32 bar, u32 offset)
 		case SOF_IPC_EXT_CC_INFO:
 			ret = get_cc_info(sdev, ext_hdr);
 			break;
+		case SOF_IPC_EXT_UNUSED:
+		case SOF_IPC_EXT_PROBE_INFO:
+		case SOF_IPC_EXT_USER_ABI_INFO:
+			/* They are supported but we don't do anything here */
+			break;
 		default:
 			dev_warn(sdev->dev, "warning: unknown ext header type %d size 0x%x\n",
 				 ext_hdr->type, ext_hdr->hdr.size);
-- 
2.27.0


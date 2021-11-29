Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3335C4626D6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbhK2W5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235758AbhK2W50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD23C12B68A;
        Mon, 29 Nov 2021 10:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8E42CE1414;
        Mon, 29 Nov 2021 18:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AF0C53FCF;
        Mon, 29 Nov 2021 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210626;
        bh=KVv4kMF9jLuKUSE7WjuzI5Ay7Lyk3PM4qDujM0Pd6ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moiF7rMbZSeMH9GhqsSd5u180kMHK8qMAen6vCs8n0Do3APwkw4F9lntX0YPQF+TC
         v16z1ldnDNxmK+P1rafjiD7NLtkwzBTEWaKkz/xuA5e2e7jAtbZvLDq1iXsbPm6KWf
         vN0wY7HbqvF8OlmLVmddInetb1AXM9EAVC23y0dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/121] ALSA: intel-dsp-config: add quirk for JSL devices based on ES8336 codec
Date:   Mon, 29 Nov 2021 19:18:12 +0100
Message-Id: <20211129181713.707296344@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit fa9730b4f28b7bd183d28a0bf636ab7108de35d7 ]

These devices are based on an I2C/I2S device, we need to force the use
of the SOF driver otherwise the legacy HDaudio driver will be loaded -
only HDMI will be supported.

We previously added support for other Intel platforms but missed
JasperLake.

BugLink: https://github.com/thesofproject/linux/issues/3210
Fixes: 9d36ceab9415 ('ALSA: intel-dsp-config: add quirk for APL/GLK/TGL devices based on ES8336 codec')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211027023254.24955-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 6cdb3db7507b1..fc61571a3ac73 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -298,6 +298,15 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 
+/* JasperLake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_JASPERLAKE)
+	{
+		.flags = FLAG_SOF,
+		.device = 0x4dc8,
+		.codec_hid = "ESSX8336",
+	},
+#endif
+
 /* Tigerlake */
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_TIGERLAKE)
 	{
-- 
2.33.0




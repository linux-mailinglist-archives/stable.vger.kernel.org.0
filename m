Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3187924DDBC
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgHURV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgHUQPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:15:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C7FD22B40;
        Fri, 21 Aug 2020 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026551;
        bh=MH/XHhgIuGUSwCqDceXgRYfcAdjj+S7B5fgn8Cpmi+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2LAcydz4BI0diKWUAh7BYgmfv4qT+YhfXUt84uXHMV5h2a+v/npvcmy79WksmE4D
         aFop6kLCFgQAFR67YVMlAHTEo4m8L/oQS3FTMcXdCmCsXM6LjNvPF3ioWSiGLZ1FpX
         QdYFFV3835O1zj7PwgeQOvpxwlC76rt+1VF3TYeU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 04/61] ALSA: hda/hdmi: Use force connectivity quirk on another HP desktop
Date:   Fri, 21 Aug 2020 12:14:48 -0400
Message-Id: <20200821161545.347622-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161545.347622-1-sashal@kernel.org>
References: <20200821161545.347622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit d96f27c80b65437a7b572647ecb4717ec9a50c98 ]

There's another HP desktop has buggy BIOS which flags the Port
Connectivity bit as no connection.

Apply force connectivity quirk to enable DP/HDMI audio.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200811095336.32396-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index de9570032e07c..1f6f6b955362e 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1805,6 +1805,7 @@ static int hdmi_add_cvt(struct hda_codec *codec, hda_nid_t cvt_nid)
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	{}
 };
-- 
2.25.1


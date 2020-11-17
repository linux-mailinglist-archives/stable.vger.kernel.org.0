Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DBB2B62F5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgKQNdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732060AbgKQNdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:33:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4A12168B;
        Tue, 17 Nov 2020 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620015;
        bh=Rl2FmOKz3FhvTMwiGKfppdkVk2uGslV89dplTpWMBbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIoEfjx8oKWMWr1+iKBuKUhJPnjJh8TKobAzbsy0fUwJiIhAsexOyscTw+85luVIH
         UhPLQHagnzNJO4/SDcV5F3ZextQQfmpaoa7q+3D6FzXzrd9IYfufxZCguf3TkLzrdO
         /107Wt+vLE6F8lkVE7G+J3gCzFa6NYihG8S7Q588=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 079/255] ASoC: SOF: loader: handle all SOF_IPC_EXT types
Date:   Tue, 17 Nov 2020 14:03:39 +0100
Message-Id: <20201117122142.796043065@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




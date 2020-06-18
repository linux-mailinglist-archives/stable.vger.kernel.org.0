Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901061FE76C
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFRBMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbgFRBMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63AE920B1F;
        Thu, 18 Jun 2020 01:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442726;
        bh=M50ufoemI63gZ3fe4MejLYNALLeX/lnGiYzNt2MofMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm5Q/iOJO3LCkplN3/4l8SoOUCoNEMs0ocVriCfLd4ubbB9Mgi5B7v0LhfXKtG7hx
         jHhuZyOo0WWwfwVOopOGgPNe2a0PW8IKSHuPNEwEcBjUgrSDHxnZhH2IS99BGwafQ+
         QaHqfafeh7PdmQiCJzeUB3uT/jQsxILahb1WYL/M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 183/388] ASoC: SOF: core: fix error return code in sof_probe_continue()
Date:   Wed, 17 Jun 2020 21:04:40 -0400
Message-Id: <20200618010805.600873-183-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 7d8785bc7adbb4dc5ba8ee06994107637848ded8 ]

Fix to return negative error code -ENOMEM from the IPC init error
handling case instead of 0, as done elsewhere in this function.

Fixes: c16211d6226d ("ASoC: SOF: Add Sound Open Firmware driver core")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200509093337.78897-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 91acfae7935c..74b438216216 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -176,6 +176,7 @@ static int sof_probe_continue(struct snd_sof_dev *sdev)
 	/* init the IPC */
 	sdev->ipc = snd_sof_ipc_init(sdev);
 	if (!sdev->ipc) {
+		ret = -ENOMEM;
 		dev_err(sdev->dev, "error: failed to init DSP IPC %d\n", ret);
 		goto ipc_err;
 	}
-- 
2.25.1


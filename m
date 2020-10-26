Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026B129A17F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408598AbgJ0AmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408969AbgJZXuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B926223AB;
        Mon, 26 Oct 2020 23:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756200;
        bh=vMMAgSfikcnpjQ3HPznBETOr9yljsKexNKRHJBcCX5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUTvTp6F8b5/BFM7ZmW8Y1ouUUOSv9Ags9z/o2v2iObxsaCdIQZmF864J9z+g/LqY
         KZnQBStbqwGO/w44D2NhHFtVsKLYxKSyib4ZAAUBi5FJ9Lv04rur+ZRlZy2ehJX6yG
         l5sf1GicGmdAEJr1CunuMyrJl4DkirL/GyCbJFc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akshu Agrawal <akshu.agrawal@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.9 043/147] ASoC: AMD: Clean kernel log from deferred probe error messages
Date:   Mon, 26 Oct 2020 19:47:21 -0400
Message-Id: <20201026234905.1022767-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akshu Agrawal <akshu.agrawal@amd.com>

[ Upstream commit f7660445c8e7fda91e8b944128554249d886b1d4 ]

While the driver waits for DAIs to be probed and retries probing,
have the error messages at debug level instead of error.

Signed-off-by: Akshu Agrawal <akshu.agrawal@amd.com>
Link: https://lore.kernel.org/r/20200826185454.5545-1-akshu.agrawal@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp3x-rt5682-max9836.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/soc/amd/acp3x-rt5682-max9836.c b/sound/soc/amd/acp3x-rt5682-max9836.c
index 406526e79af34..1a4e8ca0f99c2 100644
--- a/sound/soc/amd/acp3x-rt5682-max9836.c
+++ b/sound/soc/amd/acp3x-rt5682-max9836.c
@@ -472,12 +472,17 @@ static int acp3x_probe(struct platform_device *pdev)
 
 	ret = devm_snd_soc_register_card(&pdev->dev, card);
 	if (ret) {
-		dev_err(&pdev->dev,
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
 				"devm_snd_soc_register_card(%s) failed: %d\n",
 				card->name, ret);
-		return ret;
+		else
+			dev_dbg(&pdev->dev,
+				"devm_snd_soc_register_card(%s) probe deferred: %d\n",
+				card->name, ret);
 	}
-	return 0;
+
+	return ret;
 }
 
 static const struct acpi_device_id acp3x_audio_acpi_match[] = {
-- 
2.25.1


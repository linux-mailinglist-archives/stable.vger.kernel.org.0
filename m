Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8302A5174
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgKCUk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730274AbgKCUk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC0022226;
        Tue,  3 Nov 2020 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436056;
        bh=0iS+4XaYe7QcSjztXx3ac7r+S6yH9+n9AN3ILngNnqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=az9VhsIUA6d4Ab1TfsbB3GK3XjqyLRAiFPETCakaHQ+w2zkrMoEE/Uih3913paJap
         0uf/aSEfHPGrQU4gfWL8CB7V2SMaunCD78G6basxqGkSInMrED0EDRZNzT5FtY4JHv
         w/hVRuxtFBsdnJ7vpk/n2eMsqKsDOEOWRMpz2W7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akshu Agrawal <akshu.agrawal@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 084/391] ASoC: AMD: Clean kernel log from deferred probe error messages
Date:   Tue,  3 Nov 2020 21:32:15 +0100
Message-Id: <20201103203352.719130465@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.27.0




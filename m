Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFB75289E
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfFYJyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:54:03 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:37084 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbfFYJyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=9UOvvhwN54xu3u7rI2EtEP7sgGj7u93u/U1BkyKDW5U=; b=wrfjFybpd+uD
        MgBAu3msrTF99neE3RnHk4LbCLFt5fZ2di4xT8lp12BfefmUYBbQIyA0p3s/Md9F0Ylj4gcG7tBP8
        +0ukEqGPYfC1ZCDyHhLFbWYJxGSCgfMHAfp9z1cMSofKB7h86EYIQbxvNbbCrKwmDbNCrmAnS+Qq9
        Jv+zM=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=finisterre.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hfi9G-0004mZ-F3; Tue, 25 Jun 2019 09:53:58 +0000
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
        id 4F0A4440058; Mon, 24 Jun 2019 17:32:14 +0100 (BST)
From:   Mark Brown <broonie@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        stable@vger.kernel.org
Subject: Applied "ASoC: dapm: Adapt for debugfs API change" to the asoc tree
In-Reply-To: <20190621113357.8264-2-broonie@kernel.org>
X-Patchwork-Hint: ignore
Message-Id: <20190624163214.4F0A4440058@finisterre.sirena.org.uk>
Date:   Mon, 24 Jun 2019 17:32:14 +0100 (BST)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   ASoC: dapm: Adapt for debugfs API change

has been applied to the asoc tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-5.2

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From ceaea851b9ea75f9ea2bbefb53ff0d4b27cd5a6e Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Fri, 21 Jun 2019 12:33:57 +0100
Subject: [PATCH] ASoC: dapm: Adapt for debugfs API change

Back in ff9fb72bc07705c (debugfs: return error values, not NULL) the
debugfs APIs were changed to return error pointers rather than NULL
pointers on error, breaking the error checking in ASoC. Update the
code to use IS_ERR() and log the codes that are returned as part of
the error messages.

Fixes: ff9fb72bc07705c (debugfs: return error values, not NULL)
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-dapm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 5fc57af9cb6f..a248d88b8968 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2154,23 +2154,25 @@ void snd_soc_dapm_debugfs_init(struct snd_soc_dapm_context *dapm,
 {
 	struct dentry *d;
 
-	if (!parent)
+	if (!parent || IS_ERR(parent))
 		return;
 
 	dapm->debugfs_dapm = debugfs_create_dir("dapm", parent);
 
-	if (!dapm->debugfs_dapm) {
+	if (IS_ERR(dapm->debugfs_dapm)) {
 		dev_warn(dapm->dev,
-		       "ASoC: Failed to create DAPM debugfs directory\n");
+			 "ASoC: Failed to create DAPM debugfs directory %ld\n",
+			 PTR_ERR(dapm->debugfs_dapm));
 		return;
 	}
 
 	d = debugfs_create_file("bias_level", 0444,
 				dapm->debugfs_dapm, dapm,
 				&dapm_bias_fops);
-	if (!d)
+	if (IS_ERR(d))
 		dev_warn(dapm->dev,
-			 "ASoC: Failed to create bias level debugfs file\n");
+			 "ASoC: Failed to create bias level debugfs file: %ld\n",
+			 PTR_ERR(d));
 }
 
 static void dapm_debugfs_add_widget(struct snd_soc_dapm_widget *w)
@@ -2184,10 +2186,10 @@ static void dapm_debugfs_add_widget(struct snd_soc_dapm_widget *w)
 	d = debugfs_create_file(w->name, 0444,
 				dapm->debugfs_dapm, w,
 				&dapm_widget_power_fops);
-	if (!d)
+	if (IS_ERR(d))
 		dev_warn(w->dapm->dev,
-			"ASoC: Failed to create %s debugfs file\n",
-			w->name);
+			 "ASoC: Failed to create %s debugfs file: %ld\n",
+			 w->name, PTR_ERR(d));
 }
 
 static void dapm_debugfs_cleanup(struct snd_soc_dapm_context *dapm)
-- 
2.20.1


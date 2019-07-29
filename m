Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A083E7945D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbfG2Taj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbfG2Taj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:30:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F7721655;
        Mon, 29 Jul 2019 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428638;
        bh=cZ7HUEQurZUTQWyxwgwAlvkjhDjErbPofYKk5uukbRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDDAPR2INTLmKzUeW58EQOqMOBn8sZt61R/Wg7jRuJT6UiAiE420JxU6eEZ6sctYr
         0ea/6zDg++Yhw1DjQbqo2SZSAVFKPlX+4HOGOzOL6G62F/4iecVYDw7/0gJVo8+LDi
         3HBXWguS85GyH3Em/s2gcNzGcAIr2NGR3JAimkT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 138/293] ASoC: dapm: Adapt for debugfs API change
Date:   Mon, 29 Jul 2019 21:20:29 +0200
Message-Id: <20190729190835.122177618@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit ceaea851b9ea75f9ea2bbefb53ff0d4b27cd5a6e upstream.

Back in ff9fb72bc07705c (debugfs: return error values, not NULL) the
debugfs APIs were changed to return error pointers rather than NULL
pointers on error, breaking the error checking in ASoC. Update the
code to use IS_ERR() and log the codes that are returned as part of
the error messages.

Fixes: ff9fb72bc07705c (debugfs: return error values, not NULL)
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2120,23 +2120,25 @@ void snd_soc_dapm_debugfs_init(struct sn
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
@@ -2150,10 +2152,10 @@ static void dapm_debugfs_add_widget(stru
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



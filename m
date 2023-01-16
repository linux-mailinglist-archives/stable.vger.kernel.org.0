Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6518E66C08B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjAPOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAPOCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEC06597;
        Mon, 16 Jan 2023 06:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C3C960FD2;
        Mon, 16 Jan 2023 14:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EF4C43392;
        Mon, 16 Jan 2023 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877722;
        bh=4h4KUC5FpuOyk6IZUK3W1vwu6OuiMUrZWu9qOR0sw4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljQKFWxMIQgs8HojcaGKkMlvjXiaPBQ7NO37bVra0z3vxkc/knhw9c7eJdRXvrLcJ
         FRobung3tvjcwKIkYhdEXeZh+QaZIKj3lHZaTqQG7Gp/HylEbIS4EfCYS+AZUOnuX1
         Q63cnGEvQKfBuT7jcCueQ70uxfwLjwmHscBDo7TntuMO6oSWRr4mD8853gaRhIMMJc
         rVldQ7UcDyp+250r5iDIfPc6QeHevUd44h+axUfB9/yb6GRbkwVPFgmlNxPIUa4g/y
         r7M7Sav4P8XLTuEULIea2Pcx7YxNSAST2dEGbyupIKG3MY9K3xZE98epFGIlVrCl5q
         WShhxuoP7XGmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Curtis Malainey <cujomalainey@chromium.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        yung-chuan.liao@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 04/53] ASoC: SOF: Add FW state to debugfs
Date:   Mon, 16 Jan 2023 09:01:04 -0500
Message-Id: <20230116140154.114951-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit 9a9134fd56f6ba614ff7b2b3b0bac0bf1d0dc0c9 ]

Allow system health detection mechanisms to check the FW state, this
will allow them to check if the FW is in its "crashed" state going
forward to help automatically diagnose driver state.

Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221220125629.8469-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index d9a3ce7b69e1..ade0507328af 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -353,7 +353,9 @@ int snd_sof_dbg_init(struct snd_sof_dev *sdev)
 			return err;
 	}
 
-	return 0;
+	return snd_sof_debugfs_buf_item(sdev, &sdev->fw_state,
+					sizeof(sdev->fw_state),
+					"fw_state", 0444);
 }
 EXPORT_SYMBOL_GPL(snd_sof_dbg_init);
 
-- 
2.35.1


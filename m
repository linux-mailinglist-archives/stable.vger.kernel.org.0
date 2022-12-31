Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15D265A690
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 21:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbiLaUFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 15:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiLaUE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 15:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5415E8FE7;
        Sat, 31 Dec 2022 12:04:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E499760C23;
        Sat, 31 Dec 2022 20:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18FCC433F0;
        Sat, 31 Dec 2022 20:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672517094;
        bh=nbEQCC/a/+NsXj6d7pAHo1OtVx4lNUjq9z845PL8KLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgn1awa6j4koxcAFSCZxbWYbksP1qEevFxgKHa5AFVc35JwP8So4ENt1mQdHUYlfa
         sUn6Qz9chc3hFaOXRUtWkbZ6Vwnm0lFx87KfvROae8qmnGC+03b56qH5lv7CaWq7NO
         Twh6jvjWXMojBPUkJTKrsWd17AaQOF9XkBQfjJ/pHmPuQ2puZ4+m4RnSG0aOflJs3j
         3JUWef/odCCxrcYpfI6c8RBrePIAsT98llHeI9w9qvl3nWN4ePc2B39ePs/U7Ag77E
         DJhCmA9Aq+8EecAywFEaMbC4GMgtbgYiDEjMULYut1kiKg3fJopnfJonn9438YnK8a
         s1X77QfGSQzdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YC Hung <yc.hung@mediatek.com>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com, lgirdwood@gmail.com,
        peter.ujfalusi@linux.intel.com, yung-chuan.liao@linux.intel.com,
        ranjani.sridharan@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 4/7] ASoC: SOF: mediatek: initialize panic_info to zero
Date:   Sat, 31 Dec 2022 15:04:36 -0500
Message-Id: <20221231200439.1748686-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221231200439.1748686-1-sashal@kernel.org>
References: <20221231200439.1748686-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: YC Hung <yc.hung@mediatek.com>

[ Upstream commit 7bd220f2ba9014b78f0304178103393554b8c4fe ]

Coverity spotted that panic_info is not initialized to zero in
mtk_adsp_dump. Using uninitialized value panic_info.linenum when
calling snd_sof_get_status. Fix this coverity by initializing
panic_info struct as zero.

Signed-off-by: YC Hung <yc.hung@mediatek.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://lore.kernel.org/r/20221213115617.25086-1-yc.hung@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mtk-adsp-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/mediatek/mtk-adsp-common.c b/sound/soc/sof/mediatek/mtk-adsp-common.c
index 1e0769c668a7..de8dbe27cd0d 100644
--- a/sound/soc/sof/mediatek/mtk-adsp-common.c
+++ b/sound/soc/sof/mediatek/mtk-adsp-common.c
@@ -60,7 +60,7 @@ void mtk_adsp_dump(struct snd_sof_dev *sdev, u32 flags)
 {
 	char *level = (flags & SOF_DBG_DUMP_OPTIONAL) ? KERN_DEBUG : KERN_ERR;
 	struct sof_ipc_dsp_oops_xtensa xoops;
-	struct sof_ipc_panic_info panic_info;
+	struct sof_ipc_panic_info panic_info = {};
 	u32 stack[MTK_ADSP_STACK_DUMP_SIZE];
 	u32 status;
 
-- 
2.35.1


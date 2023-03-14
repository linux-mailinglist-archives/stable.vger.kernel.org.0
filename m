Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3876B9461
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjCNMpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjCNMon (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E6A12588;
        Tue, 14 Mar 2023 05:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6292361761;
        Tue, 14 Mar 2023 12:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25323C4339B;
        Tue, 14 Mar 2023 12:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797789;
        bh=VqcU0kjoPpaodik/tmc2o/BUXU32GcZs2CiF6oE5zjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sn9OrqdRBX3nRz6P18VSTNwiBMyXr7N/XjYvB3KnqNnh2UUMen30kAjO8brzQLtm1
         Ibhl0IdK9g5+L5z6gMMH+WPg2TTuMQN6XfaXZXtRVNduUgieuSKdZxUEybyu5Aq1Bs
         NSnVNu4PcfGtqjtzXrQWGCm9vxPC63bNS6VtAFt0DmF+j46rrbDr/Dyum6Y/fVmC7s
         vLgZlk163tO6InZVFzWgPJ/7N/DLAIKDpLj4oV6fb4keqlDvTIbVtx8N/7zT+gT1Dq
         yThnU0ZDuDpr/8ERASAs/LNxDWQfbPf/6w/T+7RyKWciTo59r3XqpPvmudCTAtvCha
         /4yzJ1WVBBMWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Lu <roger.lu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 02/13] soc: mediatek: mtk-svs: keep svs alive if CONFIG_DEBUG_FS not supported
Date:   Tue, 14 Mar 2023 08:42:54 -0400
Message-Id: <20230314124305.470657-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124305.470657-1-sashal@kernel.org>
References: <20230314124305.470657-1-sashal@kernel.org>
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

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit 8bf305087629a98224aa97769587434ea4016767 ]

Some projects might not support CONFIG_DEBUG_FS but still needs svs to be
alive. Therefore, enclose debug cmd codes with CONFIG_DEBUG_FS to make sure
svs can be alive when CONFIG_DEBUG_FS not supported.

Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-8-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 00526fd37d7b8..e55fb16fdc5ac 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -138,6 +138,7 @@
 
 static DEFINE_SPINLOCK(svs_lock);
 
+#ifdef CONFIG_DEBUG_FS
 #define debug_fops_ro(name)						\
 	static int svs_##name##_debug_open(struct inode *inode,		\
 					   struct file *filp)		\
@@ -170,6 +171,7 @@ static DEFINE_SPINLOCK(svs_lock);
 	}
 
 #define svs_dentry_data(name)	{__stringify(name), &svs_##name##_debug_fops}
+#endif
 
 /**
  * enum svsb_phase - svs bank phase enumeration
@@ -628,6 +630,7 @@ static int svs_adjust_pm_opp_volts(struct svs_bank *svsb)
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int svs_dump_debug_show(struct seq_file *m, void *p)
 {
 	struct svs_platform *svsp = (struct svs_platform *)m->private;
@@ -843,6 +846,7 @@ static int svs_create_debug_cmds(struct svs_platform *svsp)
 
 	return 0;
 }
+#endif /* CONFIG_DEBUG_FS */
 
 static u32 interpolate(u32 f0, u32 f1, u32 v0, u32 v1, u32 fx)
 {
@@ -2444,11 +2448,13 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_iounmap;
 	}
 
+#ifdef CONFIG_DEBUG_FS
 	ret = svs_create_debug_cmds(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs create debug cmds fail: %d\n", ret);
 		goto svs_probe_iounmap;
 	}
+#endif
 
 	return 0;
 
-- 
2.39.2


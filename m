Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7154070B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240600AbiFGRlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347508AbiFGRif (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C62F037;
        Tue,  7 Jun 2022 10:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F61661521;
        Tue,  7 Jun 2022 17:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D683C385A5;
        Tue,  7 Jun 2022 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623180;
        bh=7S0X/2rDjYasBRbm7ISB6YfywzqMXtHO4NIuDKhaBGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=topulX2guEeITxqF8OEUqqxEu1/ZVPWaw/y5W8ZMY78KLGui7yr/jssRev4xTnvvl
         2yiSRR8b/3kq6uVEHpFkhD+J6LWTELIetrPt6N4K2BV2aLE6+hT4EPPnexfXkU8is8
         SevhnNlmgojpJx/1ZkIRCCc86oDVSfaffOxW93JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Wei Chang <jia-wei.chang@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/452] cpufreq: mediatek: Use module_init and add module_exit
Date:   Tue,  7 Jun 2022 19:03:00 +0200
Message-Id: <20220607164918.182807424@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Wei Chang <jia-wei.chang@mediatek.com>

[ Upstream commit b7070187c81cb90549d7561c0e750d7c7eb751f4 ]

- Use module_init instead of device_initcall.
- Add a function for module_exit to unregister driver.

Signed-off-by: Jia-Wei Chang <jia-wei.chang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index f2e5ba3c539b..07ba238a0e0e 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -579,7 +579,13 @@ static int __init mtk_cpufreq_driver_init(void)
 
 	return 0;
 }
-device_initcall(mtk_cpufreq_driver_init);
+module_init(mtk_cpufreq_driver_init)
+
+static void __exit mtk_cpufreq_driver_exit(void)
+{
+	platform_driver_unregister(&mtk_cpufreq_platdrv);
+}
+module_exit(mtk_cpufreq_driver_exit)
 
 MODULE_DESCRIPTION("MediaTek CPUFreq driver");
 MODULE_AUTHOR("Pi-Cheng Chen <pi-cheng.chen@linaro.org>");
-- 
2.35.1




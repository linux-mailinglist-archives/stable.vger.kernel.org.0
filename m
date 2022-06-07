Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9354158A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376533AbiFGUgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377850AbiFGUeJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CB61E7AED;
        Tue,  7 Jun 2022 11:36:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14BE861579;
        Tue,  7 Jun 2022 18:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F5BC385A2;
        Tue,  7 Jun 2022 18:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626975;
        bh=fI/KXitLdUyMzMJrXOcCXOGK+kSgctBH+i8dgQZTFtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgfqda02p0YzODiMLDVyFm4VjNakGBox+FQdptvwhWEfLjo9sXKQG1rtKDhfQUABZ
         PmPApW89grkjxpeuPHEjAgyhtAR0DRgSH1KM4Yf18UcxRee168vrqAlar575DWQyue
         g1q+odkDEHjPMJWt+05jd3aGCES2jItCDGiqFwYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Wei Chang <jia-wei.chang@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 573/772] cpufreq: mediatek: Use module_init and add module_exit
Date:   Tue,  7 Jun 2022 19:02:45 +0200
Message-Id: <20220607165005.836807761@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 866163883b48..9d7d9c8dc184 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -580,7 +580,13 @@ static int __init mtk_cpufreq_driver_init(void)
 
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




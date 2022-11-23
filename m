Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE96356A1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbiKWJcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237903AbiKWJb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4418EC6546
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E390BB81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB2C433C1;
        Wed, 23 Nov 2022 09:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195869;
        bh=J+1Kx0Xu1j8RysoH6Mn5aTn9ofptELLjvwlbYX37jkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKNAhtRXoPyQoiWjNrypclkQd6UiuXVhEnTSpaN+BmoMwwhiavCrHNxdYa/NS96/F
         +zEXo9RZNYvyIvg97IQTIZGGR3y0WJE+DpAsgmukIfAzWfVnSjmFjoiVCsLIi/7ehq
         SAJFX6XG+Wmil7ClVInFElMALrpHqgUtsdrmz3KA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/181] ASoC: soc-utils: Remove __exit for snd_soc_util_exit()
Date:   Wed, 23 Nov 2022 09:50:18 +0100
Message-Id: <20221123084604.749036639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 314d34fe7f0a5836cb0472950c1f17744b4efde8 ]

snd_soc_util_exit() is called in __init snd_soc_init() for cleanup.
Remove the __exit annotation for it to fix the build warning:

WARNING: modpost: sound/soc/snd-soc-core.o: section mismatch in reference: init_module (section: .init.text) -> snd_soc_util_exit (section: .exit.text)

Fixes: 6ec27c53886c ("ASoC: core: Fix use-after-free in snd_soc_exit()")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221031134031.256511-1-chenzhongjin@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index 299b5d6ebfd1..f2c9d97c19c7 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -206,7 +206,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_driver_unregister(&soc_dummy_driver);
 	platform_device_unregister(soc_dummy_dev);
-- 
2.35.1




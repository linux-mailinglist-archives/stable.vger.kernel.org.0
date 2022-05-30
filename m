Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28996537F9D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbiE3NxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239279AbiE3NvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB2182160;
        Mon, 30 May 2022 06:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A3C9B80DB4;
        Mon, 30 May 2022 13:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6AFC3411A;
        Mon, 30 May 2022 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917750;
        bh=+u2Yt/xw2sPo6EAVrtuFDGeht+dJf7/yaSqLvJi8jeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paH+0t5OzOr9kuvXRaVwxHBvvA5XtZ8r2RuAwTD8Z4jMcJi1ql/jtZhaKAzVXXtfA
         gtlFFp9SooEIYwZeIo+6WMeR4T4hLD/9sbMN3frbTwjYXw4vJMWjbFmU1gOcBajt4+
         dQZrAaQjsajE9F2IhwHldE24WtLuWCbt5pq3J57UGw60zLNFzNdybJgQjworbOI/mu
         7aeaMkk8lnuNfh/m/JikQ9X19oWqk100vvNRwkUEIohWNX7cdR1NA5I7EGMa24Huqy
         Y3qI7gckBrCv1r7e3ve/jnTs93+d3YHoDSfOfYBeKqM4pNB7JCZ1SnvotmvuE9DLo/
         afTKsaI4EU7KA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com, lgirdwood@gmail.com,
        ranjani.sridharan@linux.intel.com, kai.vehmanen@linux.intel.com,
        daniel.baluta@nxp.com, perex@perex.cz, tiwai@suse.com,
        yung-chuan.liao@linux.intel.com, rander.wang@intel.com,
        peter.ujfalusi@linux.intel.com, AjitKumar.Pandey@amd.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 084/135] ASoC: SOF: amd: add missing platform_device_unregister in acp_pci_rn_probe
Date:   Mon, 30 May 2022 09:30:42 -0400
Message-Id: <20220530133133.1931716-84-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit cbcab8cd737c74c20195c31d647e19f7cb49c9b8 ]

acp_pci_rn_probe misses a call platform_device_unregister in error path,
this patch fixes that.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Link: https://lore.kernel.org/r/20220512013728.4128903-1-zhengbin13@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/pci-rn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/amd/pci-rn.c b/sound/soc/sof/amd/pci-rn.c
index 392ffbdf6417..d809d151a38c 100644
--- a/sound/soc/sof/amd/pci-rn.c
+++ b/sound/soc/sof/amd/pci-rn.c
@@ -93,6 +93,7 @@ static int acp_pci_rn_probe(struct pci_dev *pci, const struct pci_device_id *pci
 	res = devm_kzalloc(&pci->dev, sizeof(struct resource) * ARRAY_SIZE(renoir_res), GFP_KERNEL);
 	if (!res) {
 		sof_pci_remove(pci);
+		platform_device_unregister(dmic_dev);
 		return -ENOMEM;
 	}
 
-- 
2.35.1


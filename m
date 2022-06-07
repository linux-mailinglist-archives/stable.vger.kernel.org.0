Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9102954121C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357025AbiFGToD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357691AbiFGTmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112DF1B6FC4;
        Tue,  7 Jun 2022 11:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62E9160B16;
        Tue,  7 Jun 2022 18:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B223C34115;
        Tue,  7 Jun 2022 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625749;
        bh=+u2Yt/xw2sPo6EAVrtuFDGeht+dJf7/yaSqLvJi8jeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDCWLtBLVQswD3ieDK61erghmxFVPqZaPNlPf3q00wUNokUt3b/+s6C1Jhsj0pIuW
         GOOF7MCTgPddCRwM4sawLmaMWKMm9OamnEccm+6Igl9JFUtZWumDY/EgnVxSW17Izn
         Zh7MprD7hnmuRQY04uLb0H6IRN1wBbLpSBTubobQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 131/772] ASoC: SOF: amd: add missing platform_device_unregister in acp_pci_rn_probe
Date:   Tue,  7 Jun 2022 18:55:23 +0200
Message-Id: <20220607164952.903611355@linuxfoundation.org>
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




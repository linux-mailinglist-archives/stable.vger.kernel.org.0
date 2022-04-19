Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC177507733
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356252AbiDSSOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356229AbiDSSOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:14:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDE13D1C6;
        Tue, 19 Apr 2022 11:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECD22B81185;
        Tue, 19 Apr 2022 18:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DC6C385A5;
        Tue, 19 Apr 2022 18:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391880;
        bh=PppC3vam2C5Yu3j4i8ueQKhK2ayOhbdqrydENy51b+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRJZODLh6nLMIGrx8mtvLHE36/9CmM+KX5pxfSaaV5NP5V0dlYLh4JNqxQ+mfsZES
         FKOzJL9pXYK6n5eFUeLSfHn3lWiDEt/Ctx4VKrbWS5Q552goQdSCxTTImQ3aTnOl0Y
         G07p7qU9zEfh3TVXF5VP1nw36xXS++IZbdkFr0s2sipaLe+MKmgWw1w1qUjy+tb1LN
         FpiwLqZzczsCkEcuhivvoSSiEk4r8318qLuEydVIxlBPBsplsLxvAIcqQL99JOSBMV
         gnoFEUFfaC4MOMJGbX8kcUD68ih9u8h7d1vVFPJ8oAVMjFKVilrQnGt2C1NxIaQuKK
         A94UOQN08qQCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        mperttunen@nvidia.com, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 05/34] reset: tegra-bpmp: Restore Handle errors in BPMP response
Date:   Tue, 19 Apr 2022 14:10:32 -0400
Message-Id: <20220419181104.484667-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
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

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit d1da1052ffad63aa5181b69f20a6952e31f339c2 ]

This reverts following commit 69125b4b9440 ("reset: tegra-bpmp: Revert
Handle errors in BPMP response").

The Tegra194 HDA reset failure is fixed by commit d278dc9151a0 ("ALSA:
hda/tegra: Fix Tegra194 HDA reset failure"). The temporary revert of
original commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
response") can be removed now.

Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/1641995806-15245-1-git-send-email-spujar@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/tegra/reset-bpmp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/reset/tegra/reset-bpmp.c b/drivers/reset/tegra/reset-bpmp.c
index 24d3395964cc..4c5bba52b105 100644
--- a/drivers/reset/tegra/reset-bpmp.c
+++ b/drivers/reset/tegra/reset-bpmp.c
@@ -20,6 +20,7 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	struct tegra_bpmp *bpmp = to_tegra_bpmp(rstc);
 	struct mrq_reset_request request;
 	struct tegra_bpmp_message msg;
+	int err;
 
 	memset(&request, 0, sizeof(request));
 	request.cmd = command;
@@ -30,7 +31,13 @@ static int tegra_bpmp_reset_common(struct reset_controller_dev *rstc,
 	msg.tx.data = &request;
 	msg.tx.size = sizeof(request);
 
-	return tegra_bpmp_transfer(bpmp, &msg);
+	err = tegra_bpmp_transfer(bpmp, &msg);
+	if (err)
+		return err;
+	if (msg.rx.ret)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int tegra_bpmp_reset_module(struct reset_controller_dev *rstc,
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE13540B9D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350312AbiFGS3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352526AbiFGS0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:26:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E520316ABFD;
        Tue,  7 Jun 2022 10:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BA660DBA;
        Tue,  7 Jun 2022 17:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3572FC3411F;
        Tue,  7 Jun 2022 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624492;
        bh=QPi9gTEDBtbnh4IrGry16SvcsyQzH/63P+jQ5n+dKRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLnO8PqRPVONsHyNrgs5mT7Ts74FxlK9BfGBDsWsOpWUplIod8BjBdvzMxKB3qEs6
         8l9+enweCadTAKTy9Rjts73M/3TKJcPGvn0d5hGDcLvULWYt3qi1HgJkB2GmI+lSwR
         fOqul7cg1sn7sGlyou03WbDmHGWyNc9qWiPdT06vXCwEjwTQ7QzyLvT9Fv6Sa0gUFp
         G5R5i9nFv1Sw9XttaoTfMBGZSQ0uEyBZCYO1Yb/CxX+Kl/TPBWFT1fdeFDNn5bYsuo
         JaCROauYz+L2JAtkR8EcWgv80gRE5uXt1woIYBZLdvCy8gyAvDV01mctOuhWrZ6D7a
         A2PRwzUPXGocQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gong Yuanjun <ruc_gongyuanjun@163.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, ray.huang@amd.com, lijo.lazar@amd.com,
        aaron.liu@amd.com, Xiaomeng.Hou@amd.com, Perry.Yuan@amd.com,
        yifan1.zhang@amd.com, sathishkumar.sundararaju@amd.com,
        mario.limonciello@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 43/60] drm/amd/pm: fix a potential gpu_metrics_table memory leak
Date:   Tue,  7 Jun 2022 13:52:40 -0400
Message-Id: <20220607175259.478835-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

[ Upstream commit d2f4460a3d9502513419f06cc376c7ade49d5753 ]

gpu_metrics_table is allocated in yellow_carp_init_smc_tables() but
not freed in yellow_carp_fini_smc_tables().

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index 0bc84b709a93..6f7d123702bd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -190,6 +190,9 @@ static int yellow_carp_fini_smc_tables(struct smu_context *smu)
 	kfree(smu_table->watermarks_table);
 	smu_table->watermarks_table = NULL;
 
+	kfree(smu_table->gpu_metrics_table);
+	smu_table->gpu_metrics_table = NULL;
+
 	return 0;
 }
 
-- 
2.35.1


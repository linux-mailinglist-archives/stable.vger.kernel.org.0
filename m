Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8210B6148D8
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiKALai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiKAL3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2536331;
        Tue,  1 Nov 2022 04:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB9EE615E0;
        Tue,  1 Nov 2022 11:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4C0C433C1;
        Tue,  1 Nov 2022 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302127;
        bh=xdh7G/bIiGGJA9u5xFJF/ax3tcZiKlc8bZPavpkA3MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MToXO5PCTAOpwruuD+MifybG+/kXXHpi0H+DgudD695IGxp/aVeW3AXAmswM/Obuc
         nXX3M1NAOeuwzmX+M6s4itp66gWM8oKj0cUEWw4u0ISyP6WcsrbYFEtQhcr+7LIetX
         gmz6hwN1lv5rjBTPaClLiGa1Z+QP4vKlbTTTI7OcMgT+LV35WImj1MVN/3OAcSpTRI
         iwcVMmGcFSMf1wEpX1k+RYNM8vBd/lHHPx7/g3HaXkDgXB4IC+jhV4ADyQghkw8QJC
         jh9PLn2BlS74GqMW4N62JZQBjld9xy9TGxnyItryT9ywdR6InlsqK1KZmpZmsMAyYK
         ALghC+3A/BQKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>, Guan Yu <Guan.Yu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Hawking.Zhang@amd.com, lijo.lazar@amd.com,
        mario.limonciello@amd.com, tim.huang@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 27/34] drm/amd/pm: skip loading pptable from driver on secure board for smu_v13_0_10
Date:   Tue,  1 Nov 2022 07:27:19 -0400
Message-Id: <20221101112726.799368-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit f700486cd1f2bf381671d1c2c7dc9000db10c50e ]

skip loading pptable from driver on secure board since it's loaded from psp.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Guan Yu <Guan.Yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 93f9b8377539..750d8da84fac 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -210,7 +210,8 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu)
 		return 0;
 
 	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 7)) ||
-	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 0)))
+	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 0)) ||
+	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 10)))
 		return 0;
 
 	/* override pptable_id from driver parameter */
-- 
2.35.1


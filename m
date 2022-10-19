Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33E604600
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiJSMyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiJSMyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:54:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E4AF9854;
        Wed, 19 Oct 2022 05:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4457B823CD;
        Wed, 19 Oct 2022 08:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD429C433C1;
        Wed, 19 Oct 2022 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169732;
        bh=qv9KGEdx0BBKOTuqWLd9oCsaYDbi4aharn99WByuFE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf84WDqfvjt2ZtidE0P+ae1Be+ftOCyBPc6q3JX/KP3mODg89FBFtZ/GdeneyW798
         yzWLMyGLxrI9aPeem6iylEutj/p2AnQoiXVNdxT8RsIOmVEG7fpO7+Z1QDWpIfcMuN
         IeEBlgruF27ZYYfnBZO0gqdeyQlrZkcn4bFjgi7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 388/862] drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()
Date:   Wed, 19 Oct 2022 10:27:55 +0200
Message-Id: <20221019083307.092290866@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 7136f956c73c4ba50bfeb61653dfd6a9669ea915 ]

If construction of the array of work queues to handle hpd_rx_irq offload
work fails, we need to unwind. Destroy all the created workqueues and
the allocated memory for the hpd_rx_irq_offload_work_queue struct array.

Fixes: 8e794421bc98 ("drm/amd/display: Fork thread to offload work of hpd_rx_irq")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6e36427aab46..194142c581c8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1296,13 +1296,21 @@ static struct hpd_rx_irq_offload_work_queue *hpd_rx_irq_create_workqueue(struct
 
 		if (hpd_rx_offload_wq[i].wq == NULL) {
 			DRM_ERROR("create amdgpu_dm_hpd_rx_offload_wq fail!");
-			return NULL;
+			goto out_err;
 		}
 
 		spin_lock_init(&hpd_rx_offload_wq[i].offload_lock);
 	}
 
 	return hpd_rx_offload_wq;
+
+out_err:
+	for (i = 0; i < max_caps; i++) {
+		if (hpd_rx_offload_wq[i].wq)
+			destroy_workqueue(hpd_rx_offload_wq[i].wq);
+	}
+	kfree(hpd_rx_offload_wq);
+	return NULL;
 }
 
 struct amdgpu_stutter_quirk {
-- 
2.35.1




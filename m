Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B8860876B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiJVIBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiJVIAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:00:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DE81A9118;
        Sat, 22 Oct 2022 00:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F37C6B82E22;
        Sat, 22 Oct 2022 07:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61929C433D7;
        Sat, 22 Oct 2022 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424998;
        bh=bHH5Vz9WUGOiTeAeeQ+WA7OaZoShJlUuxzwNps9q4Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q74jiVVvn+zf0WRBc1MO2gU2O19xu9G151oug8af/6jlh54eYbi4LrL5KQhz5U9KT
         rBg0LHfyQvuhqVRbV7HltIzeoop9RT21WpEQuhkEVZv5ImoGhcCLr64b0luNpYj0n2
         EAVrgtVLf0+TmehszVjur9lI2cS1xPRIVeyzMAJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 327/717] drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()
Date:   Sat, 22 Oct 2022 09:23:26 +0200
Message-Id: <20221022072509.187763601@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d752aadd34bf..612970a9fe65 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1363,13 +1363,21 @@ static struct hpd_rx_irq_offload_work_queue *hpd_rx_irq_create_workqueue(struct
 
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




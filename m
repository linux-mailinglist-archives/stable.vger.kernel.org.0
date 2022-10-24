Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094F460BABD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiJXUkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiJXUjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642CE8F970;
        Mon, 24 Oct 2022 11:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10CA5B819B2;
        Mon, 24 Oct 2022 12:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D981C433D6;
        Mon, 24 Oct 2022 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615457;
        bh=YkHpepdt6bpzKZu+mkiWVGRNuH/TY19Yb5+ltB8qaCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLkUVPj8v3JEPXsfIpg1dHUqp8aBKxhMaiCmo3+0VmqIbl+Bt7EPpEX8S4uHv90N7
         XUHCu/q3WTh/FWfhRO3MYTXyb/YXz6YNtjfBBGHfRSyMmGoLZ3rxDBky5k9cIkyckF
         +FHF5bXEIsB+GMYFeznGRlYEVzauaeeUaMAcbW94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/530] drm/amdgpu: Fix memory leak in hpd_rx_irq_create_workqueue()
Date:   Mon, 24 Oct 2022 13:29:35 +0200
Message-Id: <20221024113055.547293336@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 9b815950b860..484c28919271 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1307,13 +1307,21 @@ static struct hpd_rx_irq_offload_work_queue *hpd_rx_irq_create_workqueue(struct
 
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




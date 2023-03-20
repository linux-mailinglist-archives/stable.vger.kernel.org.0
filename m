Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C87B6C17B0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjCTPQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjCTPQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:16:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5C6AD1E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:11:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A132615AC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2D5C433D2;
        Mon, 20 Mar 2023 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325072;
        bh=dl3QTd+UtKcU/FC+DFXYJAoSVrWbgV2C49IRHaIEPo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CqpNkq4RHn8hfJdcQdKc5DC2sJZscku6pNJka4shdXblo59WNU8rtSHzZXKep8o+
         rORtBzj4aDuHZEGTM6YI8OTnIxlZwhMIsSPLyqbNxNd6OVv7MGAdqs2fZTJtcGK7yW
         OEhEO2ldeqiOhjX3i9+opWLwU8tKgODQ45Agzb0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 004/211] drm/panfrost: Dont sync rpm suspension after mmu flushing
Date:   Mon, 20 Mar 2023 15:52:19 +0100
Message-Id: <20230320145513.482474143@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit ba3be66f11c3c49afaa9f49b99e21d88756229ef ]

Lockdep warns about potential circular locking dependency of devfreq
with the fs_reclaim caused by immediate device suspension when mapping is
released by shrinker. Fix it by doing the suspension asynchronously.

Reviewed-by: Steven Price <steven.price@arm.com>
Fixes: ec7eba47da86 ("drm/panfrost: Rework page table flushing and runtime PM interaction")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://lore.kernel.org/all/20230108210445.3948344-3-dmitry.osipenko@collabora.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 4e83a1891f3ed..666a5e53fe193 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -282,7 +282,7 @@ static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 	if (pm_runtime_active(pfdev->dev))
 		mmu_hw_do_operation(pfdev, mmu, iova, size, AS_COMMAND_FLUSH_PT);
 
-	pm_runtime_put_sync_autosuspend(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
 }
 
 static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
-- 
2.39.2




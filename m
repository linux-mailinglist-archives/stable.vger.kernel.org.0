Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD586C15DF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbjCTO6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 10:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjCTO6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 10:58:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1470810265
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4F316158B
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 14:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84326C433D2;
        Mon, 20 Mar 2023 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324185;
        bh=H0IG8z/hSnMcXEU0TgVUWEZOMKBbDpHAy1OGOwj/JY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbViEjXsbzNxCdzrpacDqRKiSo/3T8bicps9DxKN2OFTwVvlSaVsPe36ldbv0in50
         WiVsF8C8DK2QVmBweXNvBVNwVgOaponVDgedIi5a2vAeGm7VuyGeqy2XTyGbA+Fy5x
         NpkWnzzAqchj7xXmyTk38TrjhcBZkwuwetcRoJiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Price <steven.price@arm.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/115] drm/panfrost: Dont sync rpm suspension after mmu flushing
Date:   Mon, 20 Mar 2023 15:53:34 +0100
Message-Id: <20230320145449.441004727@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
index c3292a6bd1ae8..d6dda97e2591d 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -253,7 +253,7 @@ static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 	if (pm_runtime_active(pfdev->dev))
 		mmu_hw_do_operation(pfdev, mmu, iova, size, AS_COMMAND_FLUSH_PT);
 
-	pm_runtime_put_sync_autosuspend(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
 }
 
 static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
-- 
2.39.2




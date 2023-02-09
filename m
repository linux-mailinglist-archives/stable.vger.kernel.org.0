Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488516906A0
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjBILSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjBILSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:18:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E31C57746;
        Thu,  9 Feb 2023 03:16:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE9AD61A1E;
        Thu,  9 Feb 2023 11:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717D7C4339E;
        Thu,  9 Feb 2023 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941391;
        bh=z9Aq4DGQwNjOpCfeADpvKc/mdeeR4LNe9GE6tUrlsuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFI9QajMR6Iou3nsGBx8B74eCsqe2kwyuucE8kJsse/9RH50Td+ElyeGAM20fjETd
         cO07pMIp/a+AgnkvjXz7qNIUuo/U9Ac5yqjZxOHlHO+C5iCdmK4oyGOere/AZfimjm
         9WUscI+T54EHscO4V1r0D3NhssK/UaV6vI05DJOKL5DEe4eKbhlUeOZ68H018Bv6Me
         UT6D0GQjWvWAG3U7Mjf6XrseAlZo/u+k86EcR+ZYEWagsrSEXk2VCjecbyBbg8EGcl
         x1VsbhfCZuOzFhYtbjZuBS363ItYx2S42XeR2I5RzeUGRSRdIKElQ6SRD6Ngq6zsCw
         d+THayvFO3RUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-cachefs@redhat.com
Subject: [PATCH AUTOSEL 6.1 21/38] fscache: Use clear_and_wake_up_bit() in fscache_create_volume_work()
Date:   Thu,  9 Feb 2023 06:14:40 -0500
Message-Id: <20230209111459.1891941-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3288666c72568fe1cc7f5c5ae33dfd3ab18004c8 ]

fscache_create_volume_work() uses wake_up_bit() to wake up the processes
which are waiting for the completion of volume creation. According to
comments in wake_up_bit() and waitqueue_active(), an extra smp_mb() is
needed to guarantee the memory order between FSCACHE_VOLUME_CREATING
flag and waitqueue_active() before invoking wake_up_bit().

Fixing it by using clear_and_wake_up_bit() to add the missing memory
barrier.

Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20230113115211.2895845-3-houtao@huaweicloud.com/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/volume.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index ab8ceddf9efad..d9fdd90668b0f 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -279,8 +279,7 @@ static void fscache_create_volume_work(struct work_struct *work)
 	fscache_end_cache_access(volume->cache,
 				 fscache_access_acquire_volume_end);
 
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 	fscache_put_volume(volume, fscache_volume_put_create_work);
 }
 
-- 
2.39.0


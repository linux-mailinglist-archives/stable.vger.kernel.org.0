Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81A069CE4D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjBTN6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjBTN6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC766126F3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 083F0B80D4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A96C433EF;
        Mon, 20 Feb 2023 13:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901460;
        bh=roMVyCeTwlxU9CK+65juiWQC6lSxkp+XDcq85zYy9A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQxqsXJST03w9E+Kc4Mf5rd/Quefjy8AgJKiAtPRCOb2/nfTBgqtuWr5ObX+foWH7
         NSuoT2mAVc4GW3DcMNhgA4aN1HSRIcZ+oLwCgROhdN8kN/ubE8UpPq2EHGz1cYG8ns
         mqZ1kChsuLmvxKr4/vJbqA7JhChXOEwNIjb1Uqf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jingbo Xu <jefflexu@linux.alibaba.com>,
        Hou Tao <houtao1@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/118] fscache: Use clear_and_wake_up_bit() in fscache_create_volume_work()
Date:   Mon, 20 Feb 2023 14:35:41 +0100
Message-Id: <20230220133601.441009966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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
index 903af9d85f8b9..cdf991bdd9def 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -280,8 +280,7 @@ static void fscache_create_volume_work(struct work_struct *work)
 	fscache_end_cache_access(volume->cache,
 				 fscache_access_acquire_volume_end);
 
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 	fscache_put_volume(volume, fscache_volume_put_create_work);
 }
 
-- 
2.39.0




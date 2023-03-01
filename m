Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A3F6A72D0
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCASKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCASJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AA73AB8
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC0466145C
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F166BC433EF;
        Wed,  1 Mar 2023 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694188;
        bh=Bten+99sPVsDdM0CvDxWdS7kL5uUfLWUk6B7Uc8QbuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g63WhmSDKf/lM0WMVkcZbPxdV3/RRJb+47B4ImZLnPcKcHlUHTF0US9v1NzGli2sS
         i1mRWTJL4ZPzv79Pyr26nni52gpEnZgKr7fjob/MMBqCrrANrX0MlUXEpTSKz2BY4G
         E0lEq86QWnGKhouUB66qTW+e0heRRM1rq0uWGlys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4376a9a073770c173269@syzkaller.appspotmail.com,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/19] btrfs: send: limit number of clones and allocated memory size
Date:   Wed,  1 Mar 2023 19:08:34 +0100
Message-Id: <20230301180652.550099843@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit 33e17b3f5ab74af12aca58c515bc8424ff69a343 ]

The arg->clone_sources_count is u64 and can trigger a warning when a
huge value is passed from user space and a huge array is allocated.
Limit the allocated memory to 8MiB (can be increased if needed), which
in turn limits the number of clone sources to 8M / sizeof(struct
clone_root) = 8M / 40 = 209715.  Real world number of clones is from
tens to hundreds, so this is future proof.

Reported-by: syzbot+4376a9a073770c173269@syzkaller.appspotmail.com
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4a6ba0997e399..b081b61e97c8d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -7276,10 +7276,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	/*
 	 * Check that we don't overflow at later allocations, we request
 	 * clone_sources_count + 1 items, and compare to unsigned long inside
-	 * access_ok.
+	 * access_ok. Also set an upper limit for allocation size so this can't
+	 * easily exhaust memory. Max number of clone sources is about 200K.
 	 */
-	if (arg->clone_sources_count >
-	    ULONG_MAX / sizeof(struct clone_root) - 1) {
+	if (arg->clone_sources_count > SZ_8M / sizeof(struct clone_root)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.39.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4F4B8115
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiBPHLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:11:31 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiBPHLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:11:30 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10988267;
        Tue, 15 Feb 2022 23:10:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A3628212C5;
        Wed, 16 Feb 2022 07:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644995368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mM2dJowbf5QNHaSNgtvKbxc+Z1rNW8JEgO1Jd64FHSc=;
        b=ov3zxFT0HabJGB0aZnOlvfHnya/ZmxiC/dF6yegEPFM9iIWHctgOWhengLKeybOtmvq/1E
        uGJJ6wuc54CCl4rXnvT9JK+cg5L7Jc4TK6EBDhr2Hz126+gYTsiXQBh+DKBHQodk1G78sH
        7yVWrC6mqRkxrYgktuJZPOu7Nv7BLoM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87A6113A3A;
        Wed, 16 Feb 2022 07:09:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MCyjFCejDGJ1LgAAMHmgww
        (envelope-from <wqu@suse.com>); Wed, 16 Feb 2022 07:09:27 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH for v5.15 1/2] btrfs: don't hold CPU for too long when defragging a file
Date:   Wed, 16 Feb 2022 15:09:07 +0800
Message-Id: <67dd6f0e69c59a8554d7a2977939f94221af00c1.1644994950.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1644994950.git.wqu@suse.com>
References: <cover.1644994950.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2d192fc4c1abeb0d04d1c8cd54405ff4a0b0255b upstream.

There is a user report about "btrfs filesystem defrag" causing 120s
timeout problem.

For btrfs_defrag_file() it will iterate all file extents if called from
defrag ioctl, thus it can take a long time.

There is no reason not to release the CPU during such a long operation.

Add cond_resched() after defragged one cluster.

CC: stable@vger.kernel.org # 5.15
Link: https://lore.kernel.org/linux-btrfs/10e51417-2203-f0a4-2021-86c8511cc367@gmx.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6a863b3f6de0..38a1b68c7851 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1581,6 +1581,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 				last_len = 0;
 			}
 		}
+		cond_resched();
 	}
 
 	ret = defrag_count;
-- 
2.35.1


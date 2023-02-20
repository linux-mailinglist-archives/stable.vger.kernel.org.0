Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465F669CC74
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjBTNkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjBTNka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:40:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32CA1C58D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83234B80D4A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB604C433EF;
        Mon, 20 Feb 2023 13:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900427;
        bh=0kcqojmEZ309t71xizM8PrsJiaoyHNud+3yHVa+U/+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QO2oxvbuoWDQDwuXnukkH2kEKU0oMH3yGzqWfNLsWhC/Hf/sMs7ytDKRYa6Mr7uN
         ymYZALpCazmypm60Foboldlm+AA8uMC8wE3eT2+Bws/73JGfl5lmKURr/N9NX39TGM
         Qh6sknKut5bEVCnPo0tfDp/oyAHt4+X1TY7NCRs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/89] squashfs: harden sanity check in squashfs_read_xattr_id_table
Date:   Mon, 20 Feb 2023 14:35:04 +0100
Message-Id: <20230220133553.273986847@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 72e544b1b28325fe78a4687b980871a7e4101f76 ]

While mounting a corrupted filesystem, a signed integer '*xattr_ids' can
become less than zero.  This leads to the incorrect computation of 'len'
and 'indexes' values which can cause null-ptr-deref in copy_bio_to_actor()
or out-of-bounds accesses in the next sanity checks inside
squashfs_read_xattr_id_table().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Link: https://lkml.kernel.org/r/20230117105226.329303-2-pchelkin@ispras.ru
Fixes: 506220d2ba21 ("squashfs: add more sanity checks in xattr id lookup")
Reported-by: <syzbot+082fa4af80a5bb1a9843@syzkaller.appspotmail.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/xattr_id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index 7f718d2bf357..0c0d7882bcca 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -89,7 +89,7 @@ __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids == 0)
+	if (*xattr_ids <= 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
-- 
2.39.0




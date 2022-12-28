Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D19657CF3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbiL1Phs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiL1Phr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D2B1658D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0262361542
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A5EC433D2;
        Wed, 28 Dec 2022 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241865;
        bh=NHTW7g8YDXVengTimg9WZo8+RBxdAodiEvHs3vTBHYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9p4FlCGzKex3CY0n4gwj4ryou7LqmcrqavpwYo198r8ziFWL/NPHkC4aHXZTuxFW
         SLaJPFXJRMPv7zO/QMFg5aiXXpuIu5TSZhM1OydMzeYN4f4TO7EzOz0UddT75g72gX
         xm12snTLYQzmBo1yZW9uhtE7DPEdrgT6iSoakt6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+b892240eac461e488d51@syzkaller.appspotmail.com,
        Abdun Nihaal <abdun.nihaal@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/731] fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs
Date:   Wed, 28 Dec 2022 15:40:43 +0100
Message-Id: <20221228144312.082147609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 557d19675a470bb0a98beccec38c5dc3735c20fa ]

Syzbot reports an out of bound access in ntfs_trim_fs.
The cause of this is using a loop termination condition that compares
window index (iw) with wnd->nbits instead of wnd->nwnd, due to which the
index used for wnd->free_bits exceeds the size of the array allocated.

Fix the loop condition.

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Link: https://syzkaller.appspot.com/bug?extid=b892240eac461e488d51
Reported-by: syzbot+b892240eac461e488d51@syzkaller.appspotmail.com
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index aa184407520f..7f2055b7427a 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1432,7 +1432,7 @@ int ntfs_trim_fs(struct ntfs_sb_info *sbi, struct fstrim_range *range)
 
 	down_read_nested(&wnd->rw_lock, BITMAP_MUTEX_CLUSTERS);
 
-	for (; iw < wnd->nbits; iw++, wbit = 0) {
+	for (; iw < wnd->nwnd; iw++, wbit = 0) {
 		CLST lcn_wnd = iw * wbits;
 		struct buffer_head *bh;
 
-- 
2.35.1




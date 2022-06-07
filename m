Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DC1540E81
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353748AbiFGSy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354048AbiFGSq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70C518F2E8;
        Tue,  7 Jun 2022 11:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83ACF618FB;
        Tue,  7 Jun 2022 18:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94338C385A5;
        Tue,  7 Jun 2022 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624799;
        bh=Z2ikQh4GvH5/xZ/DTPW7k20APCT+ZlfJDSw0qWNiTLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+F7GpC9qB0i0Qexv5HWxhbe0Yh84rWNNj5NEmGlwhTBi/fa+ziSqUGcDPnCeYeEH
         THgRE5TCyEh5ltNvNqL+RiDl90qFxvApFxMIdArcWw8xdg1VWmZc00y6/K/fZGdK4D
         IRvduIxh63W5UBLh7y+zLUS37pyWEHTPk7JZrMjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 458/667] hugetlbfs: fix hugetlbfs_statfs() locking
Date:   Tue,  7 Jun 2022 19:02:03 +0200
Message-Id: <20220607164948.449157136@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 4b25f030ae69ba710eff587cabb4c57cb7e7a8a1 ]

After commit db71ef79b59b ("hugetlb: make free_huge_page irq safe"), the
subpool lock should be locked with spin_lock_irq() and all call sites was
modified as such, except for the ones in hugetlbfs_statfs().

Link: https://lkml.kernel.org/r/20220429202207.3045-1-almasrymina@google.com
Fixes: db71ef79b59b ("hugetlb: make free_huge_page irq safe")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index bb0651a4a128..d74a49b188c2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1048,12 +1048,12 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		if (sbinfo->spool) {
 			long free_pages;
 
-			spin_lock(&sbinfo->spool->lock);
+			spin_lock_irq(&sbinfo->spool->lock);
 			buf->f_blocks = sbinfo->spool->max_hpages;
 			free_pages = sbinfo->spool->max_hpages
 				- sbinfo->spool->used_hpages;
 			buf->f_bavail = buf->f_bfree = free_pages;
-			spin_unlock(&sbinfo->spool->lock);
+			spin_unlock_irq(&sbinfo->spool->lock);
 			buf->f_files = sbinfo->max_inodes;
 			buf->f_ffree = sbinfo->free_inodes;
 		}
-- 
2.35.1




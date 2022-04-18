Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713D85058C9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbiDROG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiDROFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:05:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4F53526F;
        Mon, 18 Apr 2022 06:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1314260EFE;
        Mon, 18 Apr 2022 13:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09425C385A1;
        Mon, 18 Apr 2022 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287402;
        bh=YrsqG9VUqMTAoYJeVan1oYXxDdgvs1DLA5731FaekDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upSm4uY9+jCjKeTa53EG3KfF1sJVu3aeqquG5y0LblB5cdn9mrIOtfp+xvOZo6juv
         Y6A7cYgiCZAsXWf6BkIBPABtnMYa3/Sqmljb4fOO1vdsEJyz0WClQH83oE5PDege8M
         8ag3s9j+H8rz+fpfHP1ffBcLGJvkk1yERIwb22gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.9 150/218] ubifs: Add missing iput if do_tmpfile() failed in rename whiteout
Date:   Mon, 18 Apr 2022 14:13:36 +0200
Message-Id: <20220418121203.889812594@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 716b4573026bcbfa7b58ed19fe15554bac66b082 upstream.

whiteout inode should be put when do_tmpfile() failed if inode has been
initialized. Otherwise we will get following warning during umount:
  UBIFS error (ubi0:0 pid 1494): ubifs_assert_failed [ubifs]: UBIFS
  assert failed: c->bi.dd_growth == 0, in fs/ubifs/super.c:1930
  VFS: Busy inodes after unmount of ubifs. Self-destruct in 5 seconds.

Fixes: 9e0a1fff8db56ea ("ubifs: Implement RENAME_WHITEOUT")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -376,6 +376,8 @@ out_inode:
 	make_bad_inode(inode);
 	if (!instantiated)
 		iput(inode);
+	else if (whiteout)
+		iput(*whiteout);
 out_budg:
 	ubifs_release_budget(c, &req);
 	if (!instantiated)



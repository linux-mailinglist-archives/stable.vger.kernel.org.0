Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502B6656EC4
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbiL0UeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiL0UdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96425D10F;
        Tue, 27 Dec 2022 12:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C356123F;
        Tue, 27 Dec 2022 20:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E66C43396;
        Tue, 27 Dec 2022 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173196;
        bh=5coy2AkHf0gVJ0ubfvUi/qaEtWUDktNUB6z9Ia7EXUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHhYKfyXho5RGtn/dktcOESSCsYCDSZN4eAjqZgb6F4gfBISxDhPxc3EBCtciDNjQ
         dX3Dp1R2HxE9e2PuWToH6c7J/XPGl+Q06qZQp7noNEdNDxhkG+qR8SurwcSzp3qlrh
         KTQzLFacsc7DoYkvXGlOsPrnBs6thXS15TFbnLhrDqzwUCHzo8ujEEb12MUJKhWR83
         jxpMe/u1RvrjhEZTiAmsz3n/pKO9p97kjFwRcKmlQ7wrOqxxblbPzNayN935uhpFFF
         tZmLoFIeoGDmmHiTxLTt6xFwcoHWD0sUJiRWgR9z4WxS8aXeuzZk2dRcSYGVdm/9GO
         AGFXrNO8Bp6AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 17/28] fs/ntfs3: Delete duplicate condition in ntfs_read_mft()
Date:   Tue, 27 Dec 2022 15:32:38 -0500
Message-Id: <20221227203249.1213526-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 658015167a8432b88f5d032e9d85d8fd50e5bf2c ]

There were two patches which addressed the same bug and added the same
condition:

commit 6db620863f85 ("fs/ntfs3: Validate data run offset")
commit 887bfc546097 ("fs/ntfs3: Fix slab-out-of-bounds read in run_unpack")

Delete one condition.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index d98d047c778c..e352aa37330c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -374,12 +374,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	t64 = le64_to_cpu(attr->nres.svcn);
 
-	/* offset to packed runs is out-of-bounds */
-	if (roff > asize) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	err = run_unpack_ex(run, sbi, ino, t64, le64_to_cpu(attr->nres.evcn),
 			    t64, Add2Ptr(attr, roff), asize - roff);
 	if (err < 0)
-- 
2.35.1


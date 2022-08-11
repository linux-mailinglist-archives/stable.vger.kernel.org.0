Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E525904E9
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbiHKQd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbiHKQcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:32:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C8320BC5;
        Thu, 11 Aug 2022 09:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46065B821AF;
        Thu, 11 Aug 2022 16:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE8EC433D6;
        Thu, 11 Aug 2022 16:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234240;
        bh=TXQFYiowIDfrDUvG9y4/Q5RPhYl9TiS8X+72arSky5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+sOWgpTAhpIvpMW3THag29OiyLTYpXcSAhfmnUXPsuFMslLa8VFe1+aWoa2haQQ0
         gIK8riGo0+JdQys0PYTNFxnoJ29DTQfyD4ah+zwsnkAFdQoYjz0mdJ5aI2hjNTa7u8
         eF/poL01CyIaEXXAnFKZjATCRgKyQWYKTx+9PGjJpCkAKpM/OA9Rq7zFMMvqePaIeK
         lOaXI+K6VKVhrhj50mZgHatJmyxdbzFiGRmf9GeXhfDj480G8NvV3VIujx4JPQhicJ
         bMyONuSm1m9PItwHZFSr2f+V8SsLJIzpkEb1s5wvtA2W7MnfzpkhAdiXPNDH/Xnp/p
         Ft/mHqSGzojbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 13/14] d_add_ci(): make sure we don't miss d_lookup_done()
Date:   Thu, 11 Aug 2022 12:09:41 -0400
Message-Id: <20220811160948.1542842-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160948.1542842-1-sashal@kernel.org>
References: <20220811160948.1542842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 40a3cb0d2314a41975aa385a74643878454f6eac ]

All callers of d_alloc_parallel() must make sure that resulting
in-lookup dentry (if any) will encounter __d_lookup_done() before
the final dput().  d_add_ci() might end up creating in-lookup
dentries; they are fed to d_splice_alias(), which will normally
make sure they meet __d_lookup_done().  However, it is possible
to end up with d_splice_alias() failing with ERR_PTR(-ELOOP)
without having done so.  It takes a corrupted ntfs or case-insensitive
xfs image, but neither should end up with memory corruption...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 1897833a4668..1e9f4dd94e6c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2080,6 +2080,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
+		d_lookup_done(found);
 		dput(found);
 		return res;
 	}
-- 
2.35.1


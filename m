Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968A6590443
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbiHKQci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238556AbiHKQai (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E9B56FD;
        Thu, 11 Aug 2022 09:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A4736144F;
        Thu, 11 Aug 2022 16:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B56DC433B5;
        Thu, 11 Aug 2022 16:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234179;
        bh=8VEKNFmleo6kX+dQJPpLJTTYVK4vobc5KswvQUEeM14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GShfIYexVIoAQ3SE4TGdc8rGBDIjyBn9vREGHXW3ljsa1O7KlVaqjoeotAP3PPji+
         KoEFa1EO9zF6fevoU9Gdh4weuE/KOS60V+Q/qw6xVxNdxezph2x4QZbdEGPl/vIJPy
         mUy/Eap0W+Pn/XR+MHffLxD86xT6VER7CZKtwCHhiPVfFSJfQ7AIVtz8ze8q6Sg/8N
         8hKVPK+vKJ7V0f4A6fy1YGALGAqGarw6GJnMIwaaGDMiNhdjl+6agIqpe2Gr4rM4b0
         x6y7ZyDZ0/mwOdITIc4Li4uYAYWYg0MspyMNN7fdz36wbj9X2IDOrHNL+nXNAepGyc
         ZD7cZOGvnKirg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/25] d_add_ci(): make sure we don't miss d_lookup_done()
Date:   Thu, 11 Aug 2022 12:08:19 -0400
Message-Id: <20220811160826.1541971-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
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
index b2a7f1765f0b..64b8f737af1b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2160,6 +2160,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
+		d_lookup_done(found);
 		dput(found);
 		return res;
 	}
-- 
2.35.1


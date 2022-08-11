Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB1590434
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238649AbiHKQhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiHKQgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:36:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3D372EF9;
        Thu, 11 Aug 2022 09:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C24F0B82123;
        Thu, 11 Aug 2022 16:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDE1C433D6;
        Thu, 11 Aug 2022 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234296;
        bh=fVCa7m+quxhQcodAzLQC4U6N1eBE9FmPjgrkcEVUb5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m97kBlluPMYDIy3n+ulkvXyMBi1juB8YUK8kJZAl8RjXrcXmRnz/R8T4YywhjMb6d
         LdTvSi0LeoMLEgEFu++SWAnajgmujdQns/33DiZ+y9zBBqfHu2gDzEmrw8m0r+nPi0
         ucB7XJf37RBqx7xif/sS8zGITzsbL2cDqle5hbCLZrU+1QaglQ2bXUlqlr9OxjarIW
         j+S3Yxo0Vv+cGoaZH7Dad5QrDGZukmzoyMSeC0w0ajOoxBn0yzm5VSZeyWwc7FGWQ5
         dBQ1g0jXi8K0c1iH3pSGvp+4Nr3vCLb5kx7bzdOI+PNqVyCIZ9kudiLwVntWKGhYXn
         flWENHoOrImMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/14] d_add_ci(): make sure we don't miss d_lookup_done()
Date:   Thu, 11 Aug 2022 12:10:42 -0400
Message-Id: <20220811161050.1543183-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161050.1543183-1-sashal@kernel.org>
References: <20220811161050.1543183-1-sashal@kernel.org>
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
index 9ac1290ae44f..e12246378834 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2119,6 +2119,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
+		d_lookup_done(found);
 		dput(found);
 		return res;
 	}
-- 
2.35.1


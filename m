Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83C590458
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbiHKQhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbiHKQgv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D406611A;
        Thu, 11 Aug 2022 09:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9145CB82164;
        Thu, 11 Aug 2022 16:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3496C433D6;
        Thu, 11 Aug 2022 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234336;
        bh=G5xEQW7ZVYbHbIfpH3jAQL5Gnijmtlw8o+XaJN28Zwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkPB9LUF5O4YG3MS646VNIBB7GEZbO+m4vhGgAxKUcR2UHzMdi/pCULKGWSAAH1XU
         fT6LeF4sLBan3U34ckjIIdYJh273UiloOwoYPv20dfidDlIB0jolDp4hP/v3ajcGq0
         M6X9zatv6QFmX8DlaOd9yivAEKnFPuMlPwvPa91jHribR6AZWv7dSVoB4fx5rKt0wI
         5HwVwSvw02U2mD9km69YFwr3HrK8fwrmr+/OxoD7lYoYD6MNJRE2+0lAtP1jfgddN3
         yt5fcl1erdfF6OyU7ibKQhf49Mqh6Lz6/rm3MVpal/M9JSIHHNTn8MBJr+VCX0rZx1
         tUE6lsH3Pncew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/12] d_add_ci(): make sure we don't miss d_lookup_done()
Date:   Thu, 11 Aug 2022 12:11:37 -0400
Message-Id: <20220811161144.1543598-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811161144.1543598-1-sashal@kernel.org>
References: <20220811161144.1543598-1-sashal@kernel.org>
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
index 05bad55352bb..e42c715fc9e9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2089,6 +2089,7 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
+		d_lookup_done(found);
 		dput(found);
 		return res;
 	}
-- 
2.35.1


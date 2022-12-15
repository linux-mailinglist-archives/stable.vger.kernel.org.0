Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17F464E051
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLOSLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLOSLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:11:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7BE2ED5B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4CC261EA4
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD1FC433EF;
        Thu, 15 Dec 2022 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127907;
        bh=nngRGiIU4K8reXKMuh8Wp0mTEN5EQZNiYsM0B9rOix8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEnsctL23W2qy+MziA4/FS1qLUw4HAADI2ZKTzmmrOPwZYmLl2Vuky7zUqbfegcty
         cF62CRcaXSh+/mM6RXEupCW2Pjlmwoss9cjM8cqCSTr4pRd7xsiFU+cx3bTeBWe/qA
         IQQS/38mqod7mKkn3KP7ZZJqXnT7viwOeOBKAWDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ken Schalk <kschalk@nvidia.com>,
        Miklos Szeredi <mszeredi@redhat.com>, Wu Bo <bo.wu@vivo.com>
Subject: [PATCH 5.10 05/15] fuse: always revalidate if exclusive create
Date:   Thu, 15 Dec 2022 19:10:32 +0100
Message-Id: <20221215172907.241626130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit df8629af293493757beccac2d3168fe5a315636e upstream.

Failure to do so may result in EEXIST even if the file only exists in the
cache and not in the filesystem.

The atomic nature of O_EXCL mandates that the cached state should be
ignored and existence verified anew.

Reported-by: Ken Schalk <kschalk@nvidia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Wu Bo <bo.wu@vivo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & LOOKUP_REVAL)) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;



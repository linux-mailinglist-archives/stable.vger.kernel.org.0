Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B64F6ECE0C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjDXN2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjDXN2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA23065B7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322B961E97
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49008C433D2;
        Mon, 24 Apr 2023 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342911;
        bh=BEQTPXr/8cYA5q4VrjqOEP4ZXCIWiRu6WXnBgFt9u2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQfHweqoOIFYPPqJqyfM7aaiElcWrxzQLHzSrQrxlgGl4j1Ssp01y1VhAaSbFtnFg
         7UJPAGRdL5AGF+ZA4GIqP0/uYRQqPvewTQaBC8jCLyNgUopkokwEfB3c3Sq92MBGRF
         2BRV8A3dPKocib31qyqFPzxeoS7nFW8wgHKXjyyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 6.1 85/98] fuse: always revalidate rename target dentry
Date:   Mon, 24 Apr 2023 15:17:48 +0200
Message-Id: <20230424131137.186268956@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

The previous commit df8629af2934 ("fuse: always revalidate if exclusive
create") ensures that the dentries are revalidated on O_EXCL creates.  This
commit complements it by also performing revalidation for rename target
dentries.  Otherwise, a rename target file that only exists in kernel
dentry cache but not in the filesystem will result in EEXIST if
RENAME_NOREPLACE flag is used.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -214,7 +214,7 @@ static int fuse_dentry_revalidate(struct
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;



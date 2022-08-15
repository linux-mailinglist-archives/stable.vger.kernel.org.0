Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB1D5934EF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbiHOSRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbiHOSRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:17:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089672B1A2;
        Mon, 15 Aug 2022 11:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E9454CE125A;
        Mon, 15 Aug 2022 18:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14D8C433B5;
        Mon, 15 Aug 2022 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587302;
        bh=YZjcdqOmFPhjopOUNUd6Ro9ZvDWfGHcunlWhRcl2aG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hf0+Ulv/bKQEVdvi9eN+ch+3c38+GFe011EAr7gr109J34j+GGvrTFLeFHewrGP6m
         9ZBD4NE604eLYeO4Rc2DVl4XM1WFqnGEV6W0aQ2BW/5ydDBsJL66LZdXIrl2AUem6Y
         2v17hZJ4DPhHV4mDWMy1rg639oo/G8shxE1cOhqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 041/779] fs: Add missing umask strip in vfs_tmpfile
Date:   Mon, 15 Aug 2022 19:54:45 +0200
Message-Id: <20220815180338.992610017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit ac6800e279a22b28f4fc21439843025a0d5bf03e upstream.

All creation paths except for O_TMPFILE handle umask in the vfs directly
if the filesystem doesn't support or enable POSIX ACLs. If the filesystem
does then umask handling is deferred until posix_acl_create().
Because, O_TMPFILE misses umask handling in the vfs it will not honor
umask settings. Fix this by adding the missing umask handling.

Link: https://lore.kernel.org/r/1657779088-2242-2-git-send-email-xuyang2018.jy@fujitsu.com
Fixes: 60545d0d4610 ("[O_TMPFILE] it's still short a few helpers, but infrastructure should be OK now...")
Cc: <stable@vger.kernel.org> # 4.19+
Reported-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3523,6 +3523,8 @@ struct dentry *vfs_tmpfile(struct user_n
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
 	error = dir->i_op->tmpfile(mnt_userns, dir, child, mode);
 	if (error)
 		goto out_err;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C507D681213
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbjA3OSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbjA3ORp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:17:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF01C3D91D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B81E8B8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D442C433EF;
        Mon, 30 Jan 2023 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088231;
        bh=NpE4qk2r3b6JEYuQ0FQRJxbacoXtu3zARHZ14KdC/Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlJ1rHl3dDOk9XjJPYCXqxjPfPwZsqs6OG65M+grUCy28yiFE1qAcngMfBtMiGhr6
         RbIvJLAfkVeA4wUjVDmtfiIc6/xeRM5RfcisDpr43McFADxc2xPltkETuGnKes1Hv2
         gZvWfNjUENylOkm/yanNOdon3tk+Qq4MtwI/Yo50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: [PATCH 5.15 159/204] ovl: fail on invalid uid/gid mapping at copy up
Date:   Mon, 30 Jan 2023 14:52:04 +0100
Message-Id: <20230130134323.540562837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 4f11ada10d0ad3fd53e2bd67806351de63a4f9c3 upstream.

If st_uid/st_gid doesn't have a mapping in the mounter's user_ns, then
copy-up should fail, just like it would fail if the mounter task was doing
the copy using "cp -a".

There's a corner case where the "cp -a" would succeed but copy up fail: if
there's a mapping of the invalid uid/gid (65534 by default) in the user
namespace.  This is because stat(2) will return this value if the mapping
doesn't exist in the current user_ns and "cp -a" will in turn be able to
create a file with this uid/gid.

This behavior would be inconsistent with POSIX ACL's, which return -1 for
invalid uid/gid which result in a failed copy.

For consistency and simplicity fail the copy of the st_uid/st_gid are
invalid.

Fixes: 459c7c565ac3 ("ovl: unprivieged mounts")
Cc: <stable@vger.kernel.org> # v5.11
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Seth Forshee <sforshee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -960,6 +960,10 @@ static int ovl_copy_up_one(struct dentry
 	if (err)
 		return err;
 
+	if (!kuid_has_mapping(current_user_ns(), ctx.stat.uid) ||
+	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
+		return -EOVERFLOW;
+
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {



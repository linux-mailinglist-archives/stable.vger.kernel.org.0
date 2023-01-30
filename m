Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF622681091
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbjA3OEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbjA3OEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590629EF5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E948761025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91B3C433EF;
        Mon, 30 Jan 2023 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087478;
        bh=zpZSmf0BV5gofhulIRolHvgq1rMETCReuoPPApKAlHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfS/0XLLEOT7exDRVzLWVnDbmXcPw1GAD8tkFdZkv1BDHLal25aHfv6L3R3xWS13B
         nT7tijvKyjSMcsine2VoN+OOpHGeKf1ZrXPWNS24zRGQXBk8kgyVXDQzkNvzbmB5oY
         3yk2eopmzdyIVA7c9O+Efz7y8WssurjMeLnUlyVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miklos Szeredi <mszeredi@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Subject: [PATCH 6.1 221/313] ovl: fail on invalid uid/gid mapping at copy up
Date:   Mon, 30 Jan 2023 14:50:56 +0100
Message-Id: <20230130134347.008063171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
@@ -973,6 +973,10 @@ static int ovl_copy_up_one(struct dentry
 	if (err)
 		return err;
 
+	if (!kuid_has_mapping(current_user_ns(), ctx.stat.uid) ||
+	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
+		return -EOVERFLOW;
+
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {



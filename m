Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6BC6AF55D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbjCGTYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbjCGTYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC89C2DA8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:10:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07CB86150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2844C4339B;
        Tue,  7 Mar 2023 19:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216200;
        bh=/AB8lLe797xuZkQqfz2Nwf4tUFQyMaiXEGMDWX7ZdMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojio313vKSK5QYdom+bKRlJaHcO3mD9l4Tog/ZUbG8ocoxVGWcm5w8s+Fq58HBoVT
         uSg7aoj4Q3byG9nw2XTU+0zfhR8mttDC+w37XD6mP9TvKK7Yan1oEestmpSCZtHd+G
         CsIFaHzoBwWjEAF77LsJmjeeE6+SWW+DDViMN/MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com,
        stable@kernel.org, Jun Nie <jun.nie@linaro.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 500/567] ext4: refuse to create ea block when umounted
Date:   Tue,  7 Mar 2023 18:03:56 +0100
Message-Id: <20230307165927.634454633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Nie <jun.nie@linaro.org>

commit f31173c19901a96bb2ebf6bcfec8a08df7095c91 upstream.

The ea block expansion need to access s_root while it is
already set as NULL when umount is triggered. Refuse this
request to avoid panic.

Reported-by: syzbot+2dacb8f015bf1420155f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=3613786cb88c93aa1c6a279b1df6a7b201347d08
Link: https://lore.kernel.org/r/20230103014517.495275-3-jun.nie@linaro.org
Cc: stable@kernel.org
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1422,6 +1422,13 @@ static struct inode *ext4_xattr_inode_cr
 	uid_t owner[2] = { i_uid_read(inode), i_gid_read(inode) };
 	int err;
 
+	if (inode->i_sb->s_root == NULL) {
+		ext4_warning(inode->i_sb,
+			     "refuse to create EA inode when umounting");
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/*
 	 * Let the next inode be the goal, so we try and allocate the EA inode
 	 * in the same group, or nearby one.



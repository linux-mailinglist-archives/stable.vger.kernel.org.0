Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117275AAE46
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbiIBMVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiIBMVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:21:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73053422F9;
        Fri,  2 Sep 2022 05:20:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F351B82A8F;
        Fri,  2 Sep 2022 12:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744F8C433D6;
        Fri,  2 Sep 2022 12:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121227;
        bh=AIEknmOfKkXVC+4GIuxKJQWEsOndGqgmkeZKzfxZG0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbrmJn45UlO3L5NUL7wHw6dctQCQoUHdozH/GaZE+6yE7EeNLkKH+wWaTf9Va8+zX
         4lWkomIWsn5Hpknz+u1wEFccvrR+Mdw304UAjaPlBkEG89+giatWl8//XBUARPW4Xw
         dd4esO1I+NEtB6JCNtfW0Ff4hocsyCRQW9h9Y0Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 13/31] btrfs: check if root is readonly while setting security xattr
Date:   Fri,  2 Sep 2022 14:18:39 +0200
Message-Id: <20220902121357.243832041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

commit b51111271b0352aa596c5ae8faf06939e91b3b68 upstream.

For a filesystem which has btrfs read-only property set to true, all
write operations including xattr should be denied. However, security
xattr can still be changed even if btrfs ro property is true.

This happens because xattr_permission() does not have any restrictions
on security.*, system.*  and in some cases trusted.* from VFS and
the decision is left to the underlying filesystem. See comments in
xattr_permission() for more details.

This patch checks if the root is read-only before performing the set
xattr operation.

Testcase:

  DEV=/dev/vdb
  MNT=/mnt

  mkfs.btrfs -f $DEV
  mount $DEV $MNT
  echo "file one" > $MNT/f1

  setfattr -n "security.one" -v 2 $MNT/f1
  btrfs property set /mnt ro true

  setfattr -n "security.one" -v 1 $MNT/f1

  umount $MNT

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -375,6 +375,9 @@ static int btrfs_xattr_handler_get(const
 				   struct dentry *unused, struct inode *inode,
 				   const char *name, void *buffer, size_t size)
 {
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	name = xattr_full_name(handler, name);
 	return __btrfs_getxattr(inode, name, buffer, size);
 }



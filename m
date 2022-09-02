Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D987E5AAF47
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbiIBMfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbiIBMeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9C9E3988;
        Fri,  2 Sep 2022 05:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7075562136;
        Fri,  2 Sep 2022 12:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74338C433D6;
        Fri,  2 Sep 2022 12:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121586;
        bh=lmIPIPSBVldjHAb2BCMXUesAoUg65FxjM5NXsjyYyYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpS8S7ZluCYrSrZnrOGexXXkhM2hrWJbB6HQ3NffLql60Sp3TMTUJzlkVePUYEQNE
         P82dBLC4c8cje+l00TB7FNLwQaMA59UrthLFOURBZOQDndTji8Zjd1BmZFnz/Fmmjy
         r/8XB5CFWMBlCO/3tdY8W9iF5x8XlxKLhEeb3bgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 29/56] btrfs: check if root is readonly while setting security xattr
Date:   Fri,  2 Sep 2022 14:18:49 +0200
Message-Id: <20220902121401.248191627@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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
@@ -369,6 +369,9 @@ static int btrfs_xattr_handler_set(const
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	name = xattr_full_name(handler, name);
 	return btrfs_setxattr(NULL, inode, name, buffer, size, flags);
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B6C5A49B5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiH2L2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiH2L1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:27:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C2792D0;
        Mon, 29 Aug 2022 04:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A604B80F1A;
        Mon, 29 Aug 2022 11:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5D6C433D7;
        Mon, 29 Aug 2022 11:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771789;
        bh=rFVOy60Ssxsd9xCHOb/9NOIGTIKPDZteDKKp7l8ln3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMjlZlVGbgfPGmTSDdMfZOhDb/mvYN3kQdAdw4wxjANni64FeNfSn3z6Uzri4OAH8
         oi02MDLQk8EiGROBMdLkZcOV9haKZt0pUSh1VXByzQT1hrnM6VMpjCWljJ4z6O7tHy
         6EfYZqxwm0uMmmow2A62wcfFLwmPkkxeXgI/Rl2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 098/158] btrfs: check if root is readonly while setting security xattr
Date:   Mon, 29 Aug 2022 12:59:08 +0200
Message-Id: <20220829105813.198259823@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
@@ -371,6 +371,9 @@ static int btrfs_xattr_handler_set(const
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	name = xattr_full_name(handler, name);
 	return btrfs_setxattr_trans(inode, name, buffer, size, flags);
 }



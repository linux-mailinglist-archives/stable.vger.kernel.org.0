Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21A171DED
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbgB0ONM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388567AbgB0ONL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:13:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68458246A0;
        Thu, 27 Feb 2020 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812790;
        bh=brj/SN8Nv5cyMyCMHkqbOVzue6B+jN0Rrn+n6DFRH50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BClGrV7MMfc22cQpX80ZRe8/4QMG8vgW/+44jex1nJ5UhC7QmDXObHhRM9fiCs78r
         qp4gu8UB45SA+FwV/eLg72FfgSEYqZeddKXEVtlSiV+CRv7FBXKPdXogpaDxo2Mmv8
         lsP2pCetBwgc9B2A/lJE/ieB/80eOjovVAwjtiGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 018/150] btrfs: handle logged extent failure properly
Date:   Thu, 27 Feb 2020 14:35:55 +0100
Message-Id: <20200227132235.357370622@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit bd727173e4432fe6cb70ba108dc1f3602c5409d7 upstream.

If we're allocating a logged extent we attempt to insert an extent
record for the file extent directly.  We increase
space_info->bytes_reserved, because the extent entry addition will call
btrfs_update_block_group(), which will convert the ->bytes_reserved to
->bytes_used.  However if we fail at any point while inserting the
extent entry we will bail and leave space on ->bytes_reserved, which
will trigger a WARN_ON() on umount.  Fix this by pinning the space if we
fail to insert, which is what happens in every other failure case that
involves adding the extent entry.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4430,6 +4430,8 @@ int btrfs_alloc_logged_file_extent(struc
 
 	ret = alloc_reserved_file_extent(trans, 0, root_objectid, 0, owner,
 					 offset, ins, 1);
+	if (ret)
+		btrfs_pin_extent(fs_info, ins->objectid, ins->offset, 1);
 	btrfs_put_block_group(block_group);
 	return ret;
 }



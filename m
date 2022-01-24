Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD31949A58C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370982AbiAYAGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360267AbiAXXgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:36:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE788C0ADFD2;
        Mon, 24 Jan 2022 13:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE2761509;
        Mon, 24 Jan 2022 21:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F026C340E5;
        Mon, 24 Jan 2022 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060240;
        bh=iVBtmMFos7khpdpnzC8VC+3aCQSp2wxi7CJFJLIM1oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0elHKSM3KGtYDGBNFjTP1hsEGItoaPsHpGm8gRikaa+JdbB/L3FwWSHsrBGMPgEE
         wqQx4lxRhdWSNWJE8/M1oFuqrzcyETFuQJsR5/wnkw4IVW/Pcm0/qxohTt2tkfYNQf
         a3CnXEtYG8j5IuRg28t1AtFdFC5HgDXabPiC9R4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 0885/1039] btrfs: add extent allocator hook to decide to allocate chunk or not
Date:   Mon, 24 Jan 2022 19:44:34 +0100
Message-Id: <20220124184155.038183447@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 50475cd57706359d6cc652be88369dace7a4c2eb upstream.

Introduce a new hook for an extent allocator policy. With the new
hook, a policy can decide to allocate a new block group or not. If
not, it will return -ENOSPC, so btrfs_reserve_extent() will cut the
allocation size in half and retry the allocation if min_alloc_size is
large enough.

The hook has a place holder and will be replaced with the real
implementation in the next patch.

CC: stable@vger.kernel.org # 5.16
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3947,6 +3947,19 @@ static void found_extent(struct find_fre
 	}
 }
 
+static bool can_allocate_chunk(struct btrfs_fs_info *fs_info,
+			       struct find_free_extent_ctl *ffe_ctl)
+{
+	switch (ffe_ctl->policy) {
+	case BTRFS_EXTENT_ALLOC_CLUSTERED:
+		return true;
+	case BTRFS_EXTENT_ALLOC_ZONED:
+		return true;
+	default:
+		BUG();
+	}
+}
+
 static int chunk_allocation_failed(struct find_free_extent_ctl *ffe_ctl)
 {
 	switch (ffe_ctl->policy) {
@@ -4034,6 +4047,10 @@ static int find_free_extent_update_loop(
 			struct btrfs_trans_handle *trans;
 			int exist = 0;
 
+			/*Check if allocation policy allows to create a new chunk */
+			if (!can_allocate_chunk(fs_info, ffe_ctl))
+				return -ENOSPC;
+
 			trans = current->journal_info;
 			if (trans)
 				exist = 1;



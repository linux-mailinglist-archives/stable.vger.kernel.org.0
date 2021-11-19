Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46CB4575F4
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhKSRnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235878AbhKSRnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C9C611F2;
        Fri, 19 Nov 2021 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343608;
        bh=3a+EeNU+k3yWBuiMvFTkGsQyKEc8/o5jn32fSi+RK1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtyfkunQxP1X4sXESnBkL10AeDOTX+Lkcw69XYAtfcG/vZI6AM40SjDuwgpQdYxgw
         KxlGMQ2y95AR8cT5h+KZVE5TcVPuumBmTB3tuKy/bW0O/REkY7Gu4NHyw5kHTlJist
         7p4d8RORsVN6MroH/4OKXBQPz22rVNUNRvI0jrZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 08/20] btrfs: zoned: use regular writes for relocation
Date:   Fri, 19 Nov 2021 18:39:26 +0100
Message-Id: <20211119171444.926247447@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit e6d261e3b1f777b499ce8f535ed44dd1b69278b7 upstream

Now that we have a dedicated block group for relocation, we can use
REQ_OP_WRITE instead of  REQ_OP_ZONE_APPEND for writing out the data on
relocation.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1304,6 +1304,17 @@ bool btrfs_use_zone_append(struct btrfs_
 	if (!is_data_inode(&inode->vfs_inode))
 		return false;
 
+	/*
+	 * Using REQ_OP_ZONE_APPNED for relocation can break assumptions on the
+	 * extent layout the relocation code has.
+	 * Furthermore we have set aside own block-group from which only the
+	 * relocation "process" can allocate and make sure only one process at a
+	 * time can add pages to an extent that gets relocated, so it's safe to
+	 * use regular REQ_OP_WRITE for this special case.
+	 */
+	if (btrfs_is_data_reloc_root(inode->root))
+		return false;
+
 	cache = btrfs_lookup_block_group(fs_info, start);
 	ASSERT(cache);
 	if (!cache)



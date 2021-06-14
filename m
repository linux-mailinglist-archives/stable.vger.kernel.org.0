Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9A03A6106
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhFNKlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233984AbhFNKj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0816613F0;
        Mon, 14 Jun 2021 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666854;
        bh=dA5bjy7QX3MLpTI+QsI2EARSHA+gqsgQ+gB3nd4Mz8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKX2MvTJpGiUUTJB30CxTsEA4Isfk7FO9tpedJ1Fi3L+W7PKRJroLmShFeltINkDS
         VeKc1ED7cDOSSGPxIrPwtyU/0RcuWWutyOhDvFt9oaW/dFlJFMgASlkiy4NSmxR+K7
         IloBPnJPUvrSx6Xv4eTjXfyTEj4DyqZ9jaBVlKbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 25/49] btrfs: return value from btrfs_mark_extent_written() in case of error
Date:   Mon, 14 Jun 2021 12:27:18 +0200
Message-Id: <20210614102642.691369531@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.857724541@linuxfoundation.org>
References: <20210614102641.857724541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit e7b2ec3d3d4ebeb4cff7ae45cf430182fa6a49fb upstream.

We always return 0 even in case of an error in btrfs_mark_extent_written().
Fix it to return proper error value in case of a failure. All callers
handle it.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1100,7 +1100,7 @@ int btrfs_mark_extent_written(struct btr
 	int del_nr = 0;
 	int del_slot = 0;
 	int recow;
-	int ret;
+	int ret = 0;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
@@ -1320,7 +1320,7 @@ again:
 	}
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*



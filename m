Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEAA3A63DB
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhFNLR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234868AbhFNLQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C8FD6196C;
        Mon, 14 Jun 2021 10:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667790;
        bh=7Hz+b/fDHv9EU7oBXYmcGld6hMg1Wwi39cvkxfjMdOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvw5F9WE5cjZRLCteL/RzPJ2xY626L7J0zMxul98bcZZZvMaK805BJX+UsAj05ohG
         1y0/FyBMmyHUkRWyaLW5oMsOh7l8uY1+bRq35mnYr9zbJP5jtgiMuHxRyB7owK7riV
         ox4gsO9rfEGd/SSVo4KXg2Rp+CpV1DeYT+3dY360=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 076/173] btrfs: return value from btrfs_mark_extent_written() in case of error
Date:   Mon, 14 Jun 2021 12:26:48 +0200
Message-Id: <20210614102700.687519288@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
@@ -1094,7 +1094,7 @@ int btrfs_mark_extent_written(struct btr
 	int del_nr = 0;
 	int del_slot = 0;
 	int recow;
-	int ret;
+	int ret = 0;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
@@ -1315,7 +1315,7 @@ again:
 	}
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*



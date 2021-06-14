Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8AA3A603B
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhFNKch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233036AbhFNKcK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:32:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13549611C1;
        Mon, 14 Jun 2021 10:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666607;
        bh=XQXLBCcqiSuZEFJCjokN1TxGhtqBeRt8WXewSUo4XHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzvvKqXHU8jtoyI/YDaJsRx4sieu7iHWSMdz0kukEfx8/Sn9ltz2Witz6A0BZDaVk
         uOqgu6lMKb9+p14Dx9feY0NZQPeSyiCb22IHf030UurhqMz7LYLFD24Xi0iQFIP1lj
         VlUmUpxRCSbFwHAuCfVku3riyiUV4YeCcXY5KcYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 20/34] btrfs: return value from btrfs_mark_extent_written() in case of error
Date:   Mon, 14 Jun 2021 12:27:11 +0200
Message-Id: <20210614102642.235678579@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
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
@@ -1089,7 +1089,7 @@ int btrfs_mark_extent_written(struct btr
 	int del_nr = 0;
 	int del_slot = 0;
 	int recow;
-	int ret;
+	int ret = 0;
 	u64 ino = btrfs_ino(inode);
 
 	path = btrfs_alloc_path();
@@ -1284,7 +1284,7 @@ again:
 	}
 out:
 	btrfs_free_path(path);
-	return 0;
+	return ret;
 }
 
 /*



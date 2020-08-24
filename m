Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6FF24F815
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHXJZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbgHXIxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:53:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2F812072D;
        Mon, 24 Aug 2020 08:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259196;
        bh=G343O5zXct8Gjh/XR2kSlojFg+A+zPRcw02RL1ptuFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlMAtwoefIqpbpA/TUWW2TKq4aFUeMtBLFi+F08Yeb42QkCGihr9dRKU9bevBGfv2
         Digypsykqmkq6Djy7wis29f1WsUq7GOsP7bZX10gHHkIntDtU4mLFlqf8X+sJqLQ74
         lHPwN4gKnTeU4aFSIaApHBExaAUwiAXbs1O5IZjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/50] btrfs: Move free_pages_out label in inline extent handling branch in compress_file_range
Date:   Mon, 24 Aug 2020 10:31:10 +0200
Message-Id: <20200824082352.379084187@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit cecc8d9038d164eda61fbcd72520975a554ea63e ]

This label is only executed if compress_file_range fails to create an
inline extent. So move its code in the semantically related inline
extent handling branch. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 57908ee964a20..dc520749f51db 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -629,7 +629,14 @@ cont:
 				btrfs_free_reserved_data_space_noquota(inode,
 							       start,
 							       end - start + 1);
-			goto free_pages_out;
+
+			for (i = 0; i < nr_pages; i++) {
+				WARN_ON(pages[i]->mapping);
+				put_page(pages[i]);
+			}
+			kfree(pages);
+
+			return;
 		}
 	}
 
@@ -708,13 +715,6 @@ cleanup_and_bail_uncompressed:
 	*num_added += 1;
 
 	return;
-
-free_pages_out:
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON(pages[i]->mapping);
-		put_page(pages[i]);
-	}
-	kfree(pages);
 }
 
 static void free_async_extent_pages(struct async_extent *async_extent)
-- 
2.25.1




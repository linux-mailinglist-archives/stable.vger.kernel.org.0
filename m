Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2942C2ABBDA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKINbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731653AbgKINIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC4772083B;
        Mon,  9 Nov 2020 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927305;
        bh=hewyRrPRKVDXdCUStdKPIGTlfU0j/MJx69/DskM30lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijl4oA6uBczUyOYLB4f4ir1zGqJqTdFo7ofPDZUJCmZKIgI8q8nNmvyw8PRFa3mwW
         IiMiAP5NoxbzEXE6O77MguEwL+3TzIgi3edNFy9MdBETf2NYEHgBtdsSMmQlRv/Aeq
         ImgH31kjgc7AvpQaCqi6bsw7vRCn+pqTUxszol4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 15/71] Revert "btrfs: flush write bio if we loop in extent_write_cache_pages"
Date:   Mon,  9 Nov 2020 13:55:09 +0100
Message-Id: <20201109125020.634217572@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@codethink.co.uk>

This reverts commit 860473714cbe7fbedcf92bfe3eb6d69fae8c74ff.  That
has an incorrect upstream commit reference, and was modified in a way
that conflicts with some older fixes.  We can cleanly cherry-pick the
upstream commit *after* those fixes.

Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4045,14 +4045,6 @@ retry:
 		 */
 		scanned = 1;
 		index = 0;
-
-		/*
-		 * If we're looping we could run into a page that is locked by a
-		 * writer and that writer could be waiting on writeback for a
-		 * page in our current bio, and thus deadlock, so flush the
-		 * write bio here.
-		 */
-		flush_write_bio(epd);
 		goto retry;
 	}
 



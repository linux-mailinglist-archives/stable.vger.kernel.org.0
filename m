Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AFC2338F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfETMSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730955AbfETMSF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:18:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2893C20815;
        Mon, 20 May 2019 12:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354684;
        bh=yuXrqsW5AOykBoY7rVb2cfSEQJ4ZmmgCa2bNnbmJi1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzaLH8PbRqyMf+W2KmnQTctE54kkgOgoWtJyJvIS3qMdVpjaIAjNFTjBFCWVD1iwA
         WskRNbJJAZwDALqNb2yFEMCOF8kU4LLWOCCAdyNZNY1lPOV70yAa/3iP+3EKGqEjr4
         zxp8+lcGMG+rddA6IsdaHMTo51zlLrcEkrbid/jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.9 28/44] ext4: actually request zeroing of inode table after grow
Date:   Mon, 20 May 2019 14:14:17 +0200
Message-Id: <20190520115234.494011668@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

commit 310a997fd74de778b9a4848a64be9cda9f18764a upstream.

It is never possible, that number of block groups decreases,
since only online grow is supported.

But after a growing occured, we have to zero inode tables
for just created new block groups.

Fixes: 19c5246d2516 ("ext4: add new online resize interface")
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -727,7 +727,7 @@ group_add_out:
 		if (err == 0)
 			err = err2;
 		mnt_drop_write_file(filp);
-		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
+		if (!err && (o_group < EXT4_SB(sb)->s_groups_count) &&
 		    ext4_has_group_desc_csum(sb) &&
 		    test_opt(sb, INIT_INODE_TABLE))
 			err = ext4_register_li_request(sb, o_group);



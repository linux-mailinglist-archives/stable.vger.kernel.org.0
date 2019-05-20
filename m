Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C055F23706
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbfETMTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387855AbfETMTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:19:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6391820815;
        Mon, 20 May 2019 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354784;
        bh=FNyDz1pMxz6Z+YQxf9P827uXTCVV/xaBJ++WrK60164=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZhLjBtNPThlYR2HLXkQR5vOedRmUrGBloNQkuzVpo7K3XqpNnSKUI+uqgnh2TTxq
         f7Bo637BVOnzFkBgNBZhl/DsAjeTezEr6Tfw9r2J3qur44W8RcByxJ83SCe7QqeWBW
         1Sdp7eZJtPpbdsxKXdC1Aw53+LLMXIDdQi3KgprA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 41/63] ext4: make sanity check in mballoc more strict
Date:   Mon, 20 May 2019 14:14:20 +0200
Message-Id: <20190520115235.648852887@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 31562b954b60f02acb91b7349dc6432d3f8c3c5f upstream.

The sanity check in mb_find_extent() only checked that returned extent
does not extend past blocksize * 8, however it should not extend past
EXT4_CLUSTERS_PER_GROUP(sb). This can happen when clusters_per_group <
blocksize * 8 and the tail of the bitmap is not properly filled by 1s
which happened e.g. when ancient kernels have grown the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1555,7 +1555,7 @@ static int mb_find_extent(struct ext4_bu
 		ex->fe_len += 1 << order;
 	}
 
-	if (ex->fe_start + ex->fe_len > (1 << (e4b->bd_blkbits + 3))) {
+	if (ex->fe_start + ex->fe_len > EXT4_CLUSTERS_PER_GROUP(e4b->bd_sb)) {
 		/* Should never happen! (but apparently sometimes does?!?) */
 		WARN_ON(1);
 		ext4_error(e4b->bd_sb, "corruption or bug in mb_find_extent "



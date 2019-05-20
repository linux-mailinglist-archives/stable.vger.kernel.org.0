Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D611A235F8
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbfETMay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390182AbfETMax (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D2820645;
        Mon, 20 May 2019 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355453;
        bh=Y+8Y21qUCRMYjTUDfur/iQJvKkhuVBO32bLyVOUL494=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrPjDI/oK2v7NRFVJJRMXMzJ8o203Xm0bPyEguDExk1DLiz/rOoGdoN9KCjyyo3Ds
         XrYWQH3OlANvLiWot0sTkJ9KBnpsFCr5rMHf5mCvBGEezEg7batgp9Nr+sysZWvCq6
         ATARAJPPqw781x7iVqpeK2qhN3pp8QazdpCaFSMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Theodore Tso <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>, stable@kernel.org
Subject: [PATCH 5.0 104/123] ext4: fix use-after-free in dx_release()
Date:   Mon, 20 May 2019 14:14:44 +0200
Message-Id: <20190520115251.954691616@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

commit 08fc98a4d6424af66eb3ac4e2cedd2fc927ed436 upstream.

The buffer_head (frames[0].bh) and it's corresping page can be
potentially free'd once brelse() is done inside the for loop
but before the for loop exits in dx_release(). It can be free'd
in another context, when the page cache is flushed via
drop_caches_sysctl_handler(). This results into below data abort
when accessing info->indirect_levels in dx_release().

Unable to handle kernel paging request at virtual address ffffffc17ac3e01e
Call trace:
 dx_release+0x70/0x90
 ext4_htree_fill_tree+0x2d4/0x300
 ext4_readdir+0x244/0x6f8
 iterate_dir+0xbc/0x160
 SyS_getdents64+0x94/0x174

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -871,12 +871,15 @@ static void dx_release(struct dx_frame *
 {
 	struct dx_root_info *info;
 	int i;
+	unsigned int indirect_levels;
 
 	if (frames[0].bh == NULL)
 		return;
 
 	info = &((struct dx_root *)frames[0].bh->b_data)->info;
-	for (i = 0; i <= info->indirect_levels; i++) {
+	/* save local copy, "info" may be freed after brelse() */
+	indirect_levels = info->indirect_levels;
+	for (i = 0; i <= indirect_levels; i++) {
 		if (frames[i].bh == NULL)
 			break;
 		brelse(frames[i].bh);



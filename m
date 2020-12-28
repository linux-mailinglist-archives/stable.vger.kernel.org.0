Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8B92E3F9E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502280AbgL1O1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502271AbgL1O1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A6EF20731;
        Mon, 28 Dec 2020 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165603;
        bh=ClAFoqKd4rQlBjNQV5GkKaU1Hf441krcqAmQs/nsaDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWZfSGfptHcM6aWrSlXx5dEqr4wpv9ODhW7H2glXk85imHC+9HhOaBfVZ2X3zgj+2
         sVCNfOtAQqvQqA/vap7Qtg+VlsD4Vp+G2IP011bvduvcLxRVOs1qh21O39AEGgyuol
         f2FSpvZ8E1xs4Dhr7tH05Ewao/702pkQ/VhoNK74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.10 590/717] ext4: fix an IS_ERR() vs NULL check
Date:   Mon, 28 Dec 2020 13:49:48 +0100
Message-Id: <20201228125049.178226312@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit bc18546bf68e47996a359d2533168d5770a22024 upstream.

The ext4_find_extent() function never returns NULL, it returns error
pointers.

Fixes: 44059e503b03 ("ext4: fast commit recovery path")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201023112232.GB282278@mwanda
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5815,8 +5815,8 @@ int ext4_ext_replay_update_ex(struct ino
 	int ret;
 
 	path = ext4_find_extent(inode, start, NULL, 0);
-	if (!path)
-		return -EINVAL;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 	ex = path[path->p_depth].p_ext;
 	if (!ex) {
 		ret = -EFSCORRUPTED;



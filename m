Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A102B609C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgKQNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgKQNK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:10:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3954246AE;
        Tue, 17 Nov 2020 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618658;
        bh=GpHZAgbM1Z6K1qkzlu6VKPpCLAICh6zcvF3ThYIeS4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RFY25Pe6IgGAh8Ymyfz60vyjoDOrkZfpxtWwLwPH669UxbneDib451FU3g93v4MO
         OHIfB1FQ5HdIydPF1o6dAn4/Vu2+3m1uqrHCmQd8pmH5jomVxgcPnvLy8Te9BLCok3
         Y8k5eIUFGl3MNGhqNs1ZPg21PEUQ9YI+7DxRF8eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 43/78] ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA
Date:   Tue, 17 Nov 2020 14:05:09 +0100
Message-Id: <20201117122111.209023960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

commit 174fe5ba2d1ea0d6c5ab2a7d4aa058d6d497ae4d upstream.

The macro MOPT_Q is used to indicates the mount option is related to
quota stuff and is defined to be MOPT_NOSUPPORT when CONFIG_QUOTA is
disabled.  Normally the quota options are handled explicitly, so it
didn't matter that the MOPT_STRING flag was missing, even though the
usrjquota and grpjquota mount options take a string argument.  It's
important that's present in the !CONFIG_QUOTA case, since without
MOPT_STRING, the mount option matcher will match usrjquota= followed
by an integer, and will otherwise skip the table entry, and so "mount
option not supported" error message is never reported.

[ Fixed up the commit description to better explain why the fix
  works. --TYT ]

Fixes: 26092bf52478 ("ext4: use a table-driven handler for mount options")
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Link: https://lore.kernel.org/r/1603986396-28917-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1571,8 +1571,8 @@ static const struct mount_opts {
 	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
 		       EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
 							MOPT_CLEAR | MOPT_Q},
-	{Opt_usrjquota, 0, MOPT_Q},
-	{Opt_grpjquota, 0, MOPT_Q},
+	{Opt_usrjquota, 0, MOPT_Q | MOPT_STRING},
+	{Opt_grpjquota, 0, MOPT_Q | MOPT_STRING},
 	{Opt_offusrjquota, 0, MOPT_Q},
 	{Opt_offgrpjquota, 0, MOPT_Q},
 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},



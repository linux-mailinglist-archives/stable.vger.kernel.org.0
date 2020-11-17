Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808E42B6278
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgKQN2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731490AbgKQN2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6268A246A7;
        Tue, 17 Nov 2020 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619729;
        bh=in0yQTyKBoC2KCTG+bgnuMIlQl8ZnK7UvkNW33axBss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNdKgH9+jpTEtPYghVPRITkpKjvhBKkpO/n7JNGeJ9NHK6bl4Fk7drbcediF8QAUX
         anQQr7jiKxU+Un8BGyWgbbA81zPAFduvSkillrlIpAbbEyIxZ8AfAQlWArnfaVzlPj
         3B1x/R6tpQboX9a8FNvkdA5nsFkzd7oQy11kXsjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 107/151] ext4: correctly report "not supported" for {usr,grp}jquota when !CONFIG_QUOTA
Date:   Tue, 17 Nov 2020 14:05:37 +0100
Message-Id: <20201117122126.627951265@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
@@ -1756,8 +1756,8 @@ static const struct mount_opts {
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0EE3CAA36
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbhGOTMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243698AbhGOTKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9BC61417;
        Thu, 15 Jul 2021 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375979;
        bh=eWhmhpiMqM87jdVbTbTJeoNWiAD8ZXiQSfYHQ/uJd5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHgyShSaYbTC9DLkW8Rl9zMf93LMsh7UrOu+15iTuHTz/PRpQa3PquEfFc13MX1xC
         mc5T4TZ7CreRtkB76FdqSeDdEKKcGPpBWPCnWj3pTcLxTGXCZTvDwFKY1N1cly02jb
         DbsfakVQ8UAqiyyvZiS21+lI/kB9WYB7lEzJJM1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arturo Giusti <koredump@protonmail.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 034/266] udf: Fix NULL pointer dereference in udf_symlink function
Date:   Thu, 15 Jul 2021 20:36:29 +0200
Message-Id: <20210715182620.324321032@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arturo Giusti <koredump@protonmail.com>

[ Upstream commit fa236c2b2d4436d9f19ee4e5d5924e90ffd7bb43 ]

In function udf_symlink, epos.bh is assigned with the value returned
by udf_tgetblk. The function udf_tgetblk is defined in udf/misc.c
and returns the value of sb_getblk function that could be NULL.
Then, epos.bh is used without any check, causing a possible
NULL pointer dereference when sb_getblk fails.

This fix adds a check to validate the value of epos.bh.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213083
Signed-off-by: Arturo Giusti <koredump@protonmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 3ae9f1e91984..7c7c9bbbfa57 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -934,6 +934,10 @@ static int udf_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 				iinfo->i_location.partitionReferenceNum,
 				0);
 		epos.bh = udf_tgetblk(sb, block);
+		if (unlikely(!epos.bh)) {
+			err = -ENOMEM;
+			goto out_no_entry;
+		}
 		lock_buffer(epos.bh);
 		memset(epos.bh->b_data, 0x00, bsize);
 		set_buffer_uptodate(epos.bh);
-- 
2.30.2




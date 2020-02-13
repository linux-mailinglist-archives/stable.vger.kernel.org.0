Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABF15C640
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgBMP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgBMPZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:02 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6322D246B1;
        Thu, 13 Feb 2020 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607502;
        bh=0fMboa7WxTUHjGCoh/82sHfZx5Y+QtkZ922vblYfWTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sH5YzjpdL+fKYbDYYVsK+ai6H6f9vCAqeCeCUZbWPRdAPDkzM7FzZVOfX6gblC1v
         e/35Bn3nKTgEFJ426i64Y0lzUD+U2rmhLMpd//GfjlW+i0oOJSmE1tjG/cSF+MG3c2
         3z7aMptCxq/s+fvbDeMkg1agvhb3XviP9Icdrqzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.14 050/173] f2fs: fix miscounted block limit in f2fs_statfs_project()
Date:   Thu, 13 Feb 2020 07:19:13 -0800
Message-Id: <20200213151946.599757207@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengguang Xu <cgxu519@mykernel.net>

commit acdf2172172a511f97fa21ed0ee7609a6d3b3a07 upstream.

statfs calculates Total/Used/Avail disk space in block unit,
so we should translate soft/hard prjquota limit to block unit
as well.

Below testing result shows the block/inode numbers of
Total/Used/Avail from df command are all correct afer
applying this patch.

[root@localhost quota-tools]\# ./repquota -P /dev/sdb1
---
 fs/f2fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -918,6 +918,8 @@ static int f2fs_statfs_project(struct su
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
+	if (limit)
+		limit >>= sb->s_blocksize_bits;
 
 	if (limit && buf->f_blocks > limit) {
 		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;



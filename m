Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7D0157BED
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbgBJNdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgBJMff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:35 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C5520661;
        Mon, 10 Feb 2020 12:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338135;
        bh=z+F7BMaoVgH7UEY8KHvUmM0j4mINt45jiEWcsO+nEks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4TRNrW+jQhqRfBqjBg9p9Ae4b8h58MqTAYhTsfgXN06s5ZXMn2mY3axvoHpBFuQM
         /QG1wYLDuwS3u2woibBFQsca98XGbiC+KCjwVVyfq/CnSbh8lIWYqqguSnHw/V9Vkb
         stJiDViHlOdECXoSwFUTQICHbYEvqYWV6d7hpIO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 082/195] f2fs: fix miscounted block limit in f2fs_statfs_project()
Date:   Mon, 10 Feb 2020 04:32:20 -0800
Message-Id: <20200210122313.566456073@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -1154,6 +1154,8 @@ static int f2fs_statfs_project(struct su
 	if (dquot->dq_dqb.dqb_bhardlimit &&
 			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
 		limit = dquot->dq_dqb.dqb_bhardlimit;
+	if (limit)
+		limit >>= sb->s_blocksize_bits;
 
 	if (limit && buf->f_blocks > limit) {
 		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;



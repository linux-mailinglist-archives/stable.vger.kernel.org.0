Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C453E157BE4
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgBJMfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:35:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbgBJMfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:36 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED1ED21734;
        Mon, 10 Feb 2020 12:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338135;
        bh=A9O40awmbqziwJ0f/PKZQbf9luWd1lAQFVvqSYEE6ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS3MnUmUsB+iIDaouX4rAn1+vIFj2tTFMUnaCDsSm/Xp14FdzDHil13F5aunAjm9C
         zDAEhq5vIn/n+XuJuV0n466t8q9hLb8UuuHHKsikxz65uJoHah4NX+Z62xte5wQRkq
         9Qg2lrhxg+6+ABrmuxDAlMBtJEGj3navYOUL9RoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 081/195] f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()
Date:   Mon, 10 Feb 2020 04:32:19 -0800
Message-Id: <20200210122313.440883794@linuxfoundation.org>
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

commit 909110c060f22e65756659ec6fa957ae75777e00 upstream.

Setting softlimit larger than hardlimit seems meaningless
for disk quota but currently it is allowed. In this case,
there may be a bit of comfusion for users when they run
df comamnd to directory which has project quota.

For example, we set 20M softlimit and 10M hardlimit of
block usage limit for project quota of test_dir(project id 123).

[root@hades f2fs]# repquota -P -a
---
 fs/f2fs/super.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1148,9 +1148,13 @@ static int f2fs_statfs_project(struct su
 		return PTR_ERR(dquot);
 	spin_lock(&dquot->dq_dqb_lock);
 
-	limit = (dquot->dq_dqb.dqb_bsoftlimit ?
-		 dquot->dq_dqb.dqb_bsoftlimit :
-		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_bsoftlimit)
+		limit = dquot->dq_dqb.dqb_bsoftlimit;
+	if (dquot->dq_dqb.dqb_bhardlimit &&
+			(!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
+		limit = dquot->dq_dqb.dqb_bhardlimit;
+
 	if (limit && buf->f_blocks > limit) {
 		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
 		buf->f_blocks = limit;
@@ -1159,9 +1163,13 @@ static int f2fs_statfs_project(struct su
 			 (buf->f_blocks - curblock) : 0;
 	}
 
-	limit = dquot->dq_dqb.dqb_isoftlimit ?
-		dquot->dq_dqb.dqb_isoftlimit :
-		dquot->dq_dqb.dqb_ihardlimit;
+	limit = 0;
+	if (dquot->dq_dqb.dqb_isoftlimit)
+		limit = dquot->dq_dqb.dqb_isoftlimit;
+	if (dquot->dq_dqb.dqb_ihardlimit &&
+			(!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
+		limit = dquot->dq_dqb.dqb_ihardlimit;
+
 	if (limit && buf->f_files > limit) {
 		buf->f_files = limit;
 		buf->f_ffree =



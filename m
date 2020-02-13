Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2315C62A
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBMP57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728956AbgBMPZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:15 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A09924690;
        Thu, 13 Feb 2020 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607514;
        bh=Jg2YPwfNrRdnvddyGCDdUaKjhZDrWOEC5yiut1w0o48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWOOvzYdTcQG4jwPruTthXCQcQZ8KPet578fH41EgewJN1cpLE/W3tOSbWLhjotZK
         QZzaDzA2wihgIBzlIsoopizJ9CtodAZ1iKscO5UFCas5nel3ogEoUUZ0CFlhFgO0tY
         PRiytTtODmZIFArsXzX0yu0pAxqYL2biF7yW3nbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.14 049/173] f2fs: choose hardlimit when softlimit is larger than hardlimit in f2fs_statfs_project()
Date:   Thu, 13 Feb 2020 07:19:12 -0800
Message-Id: <20200213151946.325063379@linuxfoundation.org>
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
@@ -912,9 +912,13 @@ static int f2fs_statfs_project(struct su
 		return PTR_ERR(dquot);
 	spin_lock(&dq_data_lock);
 
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
@@ -923,9 +927,13 @@ static int f2fs_statfs_project(struct su
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



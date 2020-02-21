Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438861676DC
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgBUH6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730526AbgBUH6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57BA1206ED;
        Fri, 21 Feb 2020 07:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271930;
        bh=Hf/16TbuAklWN24uDDTB5Z6VsfMwR+LS1Vq1MR6sBP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmHs3Yl/ahYhAoYPWZwsTzEZQHoalqE89naHQOKGOahVnVzcswnJcUq3yujkdq2xn
         eEGjiQqnJIdCkoEOLiVxyI7smgeQzL131WDtNBdrAECoUmBx+7PNzGM+ga1Mqd+G2w
         wFWGcatWP+IgsyGjC0dRxNrc1WqGOpN2A2MopkT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 351/399] cifs: fix NULL dereference in match_prepath
Date:   Fri, 21 Feb 2020 08:41:16 +0100
Message-Id: <20200221072435.165073948@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit fe1292686333d1dadaf84091f585ee903b9ddb84 ]

RHBZ: 1760879

Fix an oops in match_prepath() by making sure that the prepath string is not
NULL before we pass it into strcmp().

This is similar to other checks we make for example in cifs_root_iget()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 05ea0e2b7e0e8..0aa3623ae0e16 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3709,8 +3709,10 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 {
 	struct cifs_sb_info *old = CIFS_SB(sb);
 	struct cifs_sb_info *new = mnt_data->cifs_sb;
-	bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
-	bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
+	bool old_set = (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		old->prepath;
+	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
+		new->prepath;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
 		return 1;
-- 
2.20.1




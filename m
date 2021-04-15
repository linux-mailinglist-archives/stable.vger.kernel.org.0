Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AC5360DD8
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhDOPGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234773AbhDOPE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 123946142B;
        Thu, 15 Apr 2021 14:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498734;
        bh=IfbCnZZonoEn1lMj5v3JPDwXb3ImT8FQzphlUT/vIEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eobKODKBOgCm7k//G8NM994TL7f94og8u9E7sA8RLdcTewgkotSeYnqxJu2YH1LVA
         4Nf6E5n4+6CKeHEY9gs4GdZReGh/eH9tanyYUlbeXgCx5WJci8iT5/ptFLTXXuFo4D
         GCaSx9U2Tlj3T+uW13sO5JWYeBDjhTXIuZ077OSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 06/23] gfs2: report "already frozen/thawed" errors
Date:   Thu, 15 Apr 2021 16:48:13 +0200
Message-Id: <20210415144413.355711423@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit ff132c5f93c06bd4432bbab5c369e468653bdec4 ]

Before this patch, gfs2's freeze function failed to report an error
when the target file system was already frozen as it should (and as
generic vfs function freeze_super does. Similarly, gfs2's thaw function
failed to report an error when trying to thaw a file system that is not
frozen, as vfs function thaw_super does. The errors were checked, but
it always returned a 0 return code.

This patch adds the missing error return codes to gfs2 freeze and thaw.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 34ca312457a6..223ebd6b1b8d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -767,11 +767,13 @@ void gfs2_freeze_func(struct work_struct *work)
 static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	int error = 0;
+	int error;
 
 	mutex_lock(&sdp->sd_freeze_mutex);
-	if (atomic_read(&sdp->sd_freeze_state) != SFS_UNFROZEN)
+	if (atomic_read(&sdp->sd_freeze_state) != SFS_UNFROZEN) {
+		error = -EBUSY;
 		goto out;
+	}
 
 	for (;;) {
 		if (gfs2_withdrawn(sdp)) {
@@ -812,10 +814,10 @@ static int gfs2_unfreeze(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	mutex_lock(&sdp->sd_freeze_mutex);
-        if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
+	if (atomic_read(&sdp->sd_freeze_state) != SFS_FROZEN ||
 	    !gfs2_holder_initialized(&sdp->sd_freeze_gh)) {
 		mutex_unlock(&sdp->sd_freeze_mutex);
-                return 0;
+		return -EINVAL;
 	}
 
 	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
-- 
2.30.2




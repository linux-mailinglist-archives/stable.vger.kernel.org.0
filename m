Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F540E07B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhIPQVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241222AbhIPQPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB03D613CE;
        Thu, 16 Sep 2021 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808683;
        bh=Q0lK3HoIcSET0s++2jaRwIXt4hru6VLJ3SveAsdzYjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuappmrBX2XRwAAA8cVokRlFs0UHyl8oVZURyCNetXnlaNvGmZqXHmSXmeu1tHGa5
         bL0qf/CDbRVyhqzP2t2ymKCoFFGYTE286XuEa63sZ+0ZnFGR76flP2pFyuWP3hEvGM
         m/0RyNwQgw66PWkiZzCfuFzpRqImc1zWd2sJVxzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/306] gfs2: Fix glock recursion in freeze_go_xmote_bh
Date:   Thu, 16 Sep 2021 17:58:49 +0200
Message-Id: <20210916155800.353176323@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 9d9b16054b7d357afde69a027514c695092b0d22 ]

We must not call gfs2_consist (which does a file system withdraw) from
the freeze glock's freeze_go_xmote_bh function because the withdraw
will try to use the freeze glock, thus causing a glock recursion error.

This patch changes freeze_go_xmote_bh to call function
gfs2_assert_withdraw_delayed instead of gfs2_consist to avoid recursion.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glops.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 3faa421568b0..bf539eab92c6 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -623,16 +623,13 @@ static int freeze_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
 		j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 		error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-		if (error)
-			gfs2_consist(sdp);
-		if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT))
-			gfs2_consist(sdp);
-
-		/*  Initialize some head of the log stuff  */
-		if (!gfs2_withdrawn(sdp)) {
-			sdp->sd_log_sequence = head.lh_sequence + 1;
-			gfs2_log_pointers_init(sdp, head.lh_blkno);
-		}
+		if (gfs2_assert_withdraw_delayed(sdp, !error))
+			return error;
+		if (gfs2_assert_withdraw_delayed(sdp, head.lh_flags &
+						 GFS2_LOG_HEAD_UNMOUNT))
+			return -EIO;
+		sdp->sd_log_sequence = head.lh_sequence + 1;
+		gfs2_log_pointers_init(sdp, head.lh_blkno);
 	}
 	return 0;
 }
-- 
2.30.2




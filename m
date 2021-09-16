Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756C040E3BF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbhIPQvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344778AbhIPQsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B4E361503;
        Thu, 16 Sep 2021 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809648;
        bh=hBMpEcqTLqk1Iuuh/VqFCCsSi3SUvQ2kusH5coJhz90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEPfWVLprWjamuHT7wot2bB4DS1L4RhprvMhzMyhfxObM3ZWAVux0AB2MNdOhNYRs
         rfwButiiQ506Hfy+wx2xPiK0IR5wChHj5nwmWrPFZLh/F/NwOHz5UTYKd2Mvv+f4Sr
         vscLUFbq61tJnI++YKOJN5tpFZyuKVCGhtyjNlHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 231/380] gfs2: Fix glock recursion in freeze_go_xmote_bh
Date:   Thu, 16 Sep 2021 17:59:48 +0200
Message-Id: <20210916155811.941403711@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 54d3fbeb3002..384565d63eea 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -610,16 +610,13 @@ static int freeze_go_xmote_bh(struct gfs2_glock *gl)
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




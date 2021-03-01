Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3463291EF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbhCAUgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241903AbhCAUaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3478765423;
        Mon,  1 Mar 2021 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622085;
        bh=B80YRp/7AA26IplR2HANq+/DG792ovrZ/pYg/GFHkK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVM7jRp0nP+4LfIpo6kuUoyi0VCfmF8IDSwcjm7F64oQtjPqwL6Znr4MQVPXGwNEj
         Fq6fVSMfb+U4KHhe8RjSQlZy912HZ3X8/fEY4lApkZnsnGLBeCR/J5d5K37fyBieMx
         j+5Dr2HvLz1zHqYWWFwNrB4rvfmA1Mm83ZmXSDjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.11 751/775] gfs2: Lock imbalance on error path in gfs2_recover_one
Date:   Mon,  1 Mar 2021 17:15:19 +0100
Message-Id: <20210301161238.424924789@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 834ec3e1ee65029029225a86c12337a6cd385af7 upstream.

In gfs2_recover_one, fix a sd_log_flush_lock imbalance when a recovery
pass fails.

Fixes: c9ebc4b73799 ("gfs2: allow journal replay to hold sd_log_flush_lock")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/recovery.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -514,8 +514,10 @@ void gfs2_recover_func(struct work_struc
 			error = foreach_descriptor(jd, head.lh_tail,
 						   head.lh_blkno, pass);
 			lops_after_scan(jd, error, pass);
-			if (error)
+			if (error) {
+				up_read(&sdp->sd_log_flush_lock);
 				goto fail_gunlock_thaw;
+			}
 		}
 
 		recover_local_statfs(jd, &head);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1EA328F80
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241908AbhCATw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242161AbhCAToB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E1465293;
        Mon,  1 Mar 2021 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619949;
        bh=B80YRp/7AA26IplR2HANq+/DG792ovrZ/pYg/GFHkK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SpwChOVKvovQ3at3fh2rSKSDg+vHAkVha1HnzMk3eRU5agm1x0TSqjOMqvjyfGIw
         npbzs9RMR/Ie5hyCEvBG8QPobLW2yo6oHeBXqGb3r2MyYOFd2DaU4EtRMTFaDzvqkb
         GaF67Qx8FnMc3JhvcnUDL3WrhaSXV6gePzw5l0LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.10 639/663] gfs2: Lock imbalance on error path in gfs2_recover_one
Date:   Mon,  1 Mar 2021 17:14:47 +0100
Message-Id: <20210301161213.472360491@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589AE3A035A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbhFHTQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236102AbhFHTNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:13:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8471A61973;
        Tue,  8 Jun 2021 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178190;
        bh=vAGZtliyhq6tXfRgZjN/CmPnhW4j1CneJYnU3iRYzB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbPI4jbzQ2OIcwGcQ1qKsDQOmWahj5YZOydxXnckUkS6w1ID8riDbsQLq7QBfj5cc
         the2pU8YkZS/nLBOl13ZOms+nsIfxgS3Yqj2+EcfZKZKtODrP5Kh+fv+vIFpFRyn9Z
         CloyIOPLisWWelfuoKY1IFZr27RS05O/4Tuof7gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.12 110/161] gfs2: fix scheduling while atomic bug in glocks
Date:   Tue,  8 Jun 2021 20:27:20 +0200
Message-Id: <20210608175949.182484972@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 20265d9a67e40eafd39a8884658ca2e36f05985d upstream.

Before this patch, in the unlikely event that gfs2_glock_dq encountered
a withdraw, it would do a wait_on_bit to wait for its journal to be
recovered, but it never released the glock's spin_lock, which caused a
scheduling-while-atomic error.

This patch unlocks the lockref spin_lock before waiting for recovery.

Fixes: 601ef0d52e96 ("gfs2: Force withdraw to replay journals and wait for it to finish")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1465,9 +1465,11 @@ void gfs2_glock_dq(struct gfs2_holder *g
 	    glock_blocked_by_withdraw(gl) &&
 	    gh->gh_gl != sdp->sd_jinode_gl) {
 		sdp->sd_glock_dqs_held++;
+		spin_unlock(&gl->gl_lockref.lock);
 		might_sleep();
 		wait_on_bit(&sdp->sd_flags, SDF_WITHDRAW_RECOVERY,
 			    TASK_UNINTERRUPTIBLE);
+		spin_lock(&gl->gl_lockref.lock);
 	}
 	if (gh->gh_flags & GL_NOCACHE)
 		handle_callback(gl, LM_ST_UNLOCKED, 0, false);



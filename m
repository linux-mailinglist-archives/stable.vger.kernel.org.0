Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745882A583F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgKCUtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731476AbgKCUtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304E9223FD;
        Tue,  3 Nov 2020 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436553;
        bh=dhcROChYc6uCOfhW4sTqa5kYsBfKaACXb38YQFIBvqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mo0NBVkUdmmsw0TFlMEbcG6eZBTurppAl+dBushW36m5Xad/pPSJUAzldF6QpPcou
         XargAPmeccEE7CWbG622uZ88XGbad6jinPQRLeJNI7lBD519CtjG1Ly4MGpO4Y3xl/
         57FUqeCkbnSyWaxQSN9P0zErg9L9MlVg+Fu4eFxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.9 299/391] gfs2: Only access gl_delete for iopen glocks
Date:   Tue,  3 Nov 2020 21:35:50 +0100
Message-Id: <20201103203407.257675059@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

commit 2ffed5290b3bff7562d29fd06621be4705704242 upstream.

Only initialize gl_delete for iopen glocks, but more importantly, only access
it for iopen glocks in flush_delete_work: flush_delete_work is called for
different types of glocks including rgrp glocks, and those use gl_vm which is
in a union with gl_delete.  Without this fix, we'll end up clobbering gl_vm,
which results in general memory corruption.

Fixes: a0e3cc65fa29 ("gfs2: Turn gl_delete into a delayed work")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/glock.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1054,7 +1054,8 @@ int gfs2_glock_get(struct gfs2_sbd *sdp,
 	gl->gl_object = NULL;
 	gl->gl_hold_time = GL_GLOCK_DFT_HOLD;
 	INIT_DELAYED_WORK(&gl->gl_work, glock_work_func);
-	INIT_DELAYED_WORK(&gl->gl_delete, delete_work_func);
+	if (gl->gl_name.ln_type == LM_TYPE_IOPEN)
+		INIT_DELAYED_WORK(&gl->gl_delete, delete_work_func);
 
 	mapping = gfs2_glock2aspace(gl);
 	if (mapping) {
@@ -1906,9 +1907,11 @@ bool gfs2_delete_work_queued(const struc
 
 static void flush_delete_work(struct gfs2_glock *gl)
 {
-	if (cancel_delayed_work(&gl->gl_delete)) {
-		queue_delayed_work(gfs2_delete_workqueue,
-				   &gl->gl_delete, 0);
+	if (gl->gl_name.ln_type == LM_TYPE_IOPEN) {
+		if (cancel_delayed_work(&gl->gl_delete)) {
+			queue_delayed_work(gfs2_delete_workqueue,
+					   &gl->gl_delete, 0);
+		}
 	}
 	gfs2_glock_queue_work(gl, 0);
 }



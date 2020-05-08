Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD391CABB3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgEHMqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgEHMqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA75D24958;
        Fri,  8 May 2020 12:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941966;
        bh=uh5EsysWk1LI2D/FsNTIwEbz2Aq7G3kDJB+f921ETFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVkZ0fXffKdkFs7EVc/O9QWXmrj1e3xnwIKkbNNlgZ8Uqf9fHGXr56A0yHT5NfK21
         EOFfgc6TLMNeSAeUAqsGqLL3ebptZfRphbrSkwm2D7/Toi1p6aYbYzqPvgbCpwaqP4
         XITsErIFiv2KSabbEM0YqQN9zt9ezGDwZom4tLBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junxiao Bi <junxiao.bi@oracle.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 4.4 244/312] gfs2: fix flock panic issue
Date:   Fri,  8 May 2020 14:33:55 +0200
Message-Id: <20200508123141.582563103@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Bi <junxiao.bi@oracle.com>

commit a93a99838248bdab49db2eaac00236847670bc7f upstream.

Commit 4f6563677ae8 ("Move locks API users to locks_lock_inode_wait()")
moved flock/posix lock identify code to locks_lock_inode_wait(), but
missed to set fl_flags to FL_FLOCK which will cause kernel panic in
locks_lock_inode_wait().

Fixes: 4f6563677ae8 ("Move locks API users to locks_lock_inode_wait()")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1035,7 +1035,10 @@ static int do_flock(struct file *file, i
 		if (fl_gh->gh_state == state)
 			goto out;
 		locks_lock_file_wait(file,
-				     &(struct file_lock){.fl_type = F_UNLCK});
+				     &(struct file_lock) {
+					     .fl_type = F_UNLCK,
+					     .fl_flags = FL_FLOCK
+				     });
 		gfs2_glock_dq(fl_gh);
 		gfs2_holder_reinit(state, flags, fl_gh);
 	} else {



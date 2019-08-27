Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B619E1EA
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfH0HxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbfH0HxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:53:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF1EC217F5;
        Tue, 27 Aug 2019 07:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892394;
        bh=NowFkdEu21UO3lyhuKThxidzyxj5RXtdZ+GwbRkJ17E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWml8olDwdKG103Afgx9FcmG9Fx2pJG3hPRwoR6qjD4nPrnINHriqCZDRppPFCmG3
         3+WdGalo/xK7KOwf+CqiYzAbJNmxep3RVG5BqGH0UaHFrEe1duDEyIo3mMczgUe0g4
         cVgQ89rVxeBx3IEy8BI/gh5T3u7QSO3z6yRKEImo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <hector@marcansoft.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.14 39/62] ceph: dont try fill file_lock on unsuccessful GETFILELOCK reply
Date:   Tue, 27 Aug 2019 09:50:44 +0200
Message-Id: <20190827072702.894262572@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 28a282616f56990547b9dcd5c6fbd2001344664c upstream.

When ceph_mdsc_do_request returns an error, we can't assume that the
filelock_reply pointer will be set. Only try to fetch fields out of
the r_reply_info when it returns success.

Cc: stable@vger.kernel.org
Reported-by: Hector Martin <hector@marcansoft.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/locks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -78,8 +78,7 @@ static int ceph_lock_message(u8 lock_typ
 		req->r_wait_for_completion = ceph_lock_wait_for_completion;
 
 	err = ceph_mdsc_do_request(mdsc, inode, req);
-
-	if (operation == CEPH_MDS_OP_GETFILELOCK) {
+	if (!err && operation == CEPH_MDS_OP_GETFILELOCK) {
 		fl->fl_pid = -le64_to_cpu(req->r_reply_info.filelock_reply->pid);
 		if (CEPH_LOCK_SHARED == req->r_reply_info.filelock_reply->type)
 			fl->fl_type = F_RDLCK;



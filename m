Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB88C1D0EC4
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbgEMJuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387459AbgEMJuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6781320740;
        Wed, 13 May 2020 09:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363411;
        bh=59zeFVD0BiQV6wVNQvdmW3dX3E0raA5rPJYbte2mkoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P91uPjZY0Gk3QA6XCMCBNDlXcaUqMzVIFGR4t77XB8e/7yNO3OpNzjfaDDWQcxoJ1
         gGjVdR2pULpAnPpfZGTTddLGdK6UFgvnKJf+hbYMplksMbSTNyHcXoU090OgbpASkl
         fVp5amnn21V9FhQKrbvUcLsKi+9K7hGvbDehxn64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Henriques <lhenriques@suse.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.4 63/90] ceph: demote quotarealm lookup warning to a debug message
Date:   Wed, 13 May 2020 11:44:59 +0200
Message-Id: <20200513094416.160679537@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Henriques <lhenriques@suse.com>

commit 12ae44a40a1be891bdc6463f8c7072b4ede746ef upstream.

A misconfigured cephx can easily result in having the kernel client
flooding the logs with:

  ceph: Can't lookup inode 1 (err: -13)

Change this message to debug level.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/44546
Signed-off-by: Luis Henriques <lhenriques@suse.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/quota.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -159,8 +159,8 @@ static struct inode *lookup_quotarealm_i
 	}
 
 	if (IS_ERR(in)) {
-		pr_warn("Can't lookup inode %llx (err: %ld)\n",
-			realm->ino, PTR_ERR(in));
+		dout("Can't lookup inode %llx (err: %ld)\n",
+		     realm->ino, PTR_ERR(in));
 		qri->timeout = jiffies + msecs_to_jiffies(60 * 1000); /* XXX */
 	} else {
 		qri->timeout = 0;



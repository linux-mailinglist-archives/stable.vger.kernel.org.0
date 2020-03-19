Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54E118B743
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgCSNQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbgCSNQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFD412098B;
        Thu, 19 Mar 2020 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623764;
        bh=N1IvcdAKJkHcF6FqQ5d89QbwvvBcmY/Vecti2b3XLfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iM6NXWH2lC3RkJB5BtlzTAgR6hkPTp4NheCZROuphDmSk9DxV8jA/DAYkQMbbKBFY
         7T+eOfMbP4okiNi+kCVVnqN8HsgCzl23iMq2URUU74IJbx/LxUT3eEe1sOQIbA3rQl
         7eOA83dSPVJXAL4eu9LSgXHPmga8G2dhj+vQgjxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.14 46/99] gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache
Date:   Thu, 19 Mar 2020 14:03:24 +0100
Message-Id: <20200319123955.852659047@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 21039132650281de06a169cbe8a0f7e5c578fd8b upstream.

with the way fs/namei.c:do_last() had been done, ->atomic_open()
instances needed to recognize the case when existing file got
found with O_EXCL|O_CREAT, either by falling back to finish_no_open()
or failing themselves.  gfs2 one didn't.

Fixes: 6d4ade986f9c (GFS2: Add atomic_open support)
Cc: stable@kernel.org # v3.11
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1255,7 +1255,7 @@ static int gfs2_atomic_open(struct inode
 		if (!(*opened & FILE_OPENED))
 			return finish_no_open(file, d);
 		dput(d);
-		return 0;
+		return excl && (flags & O_CREAT) ? -EEXIST : 0;
 	}
 
 	BUG_ON(d != NULL);



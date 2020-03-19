Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45D118B82D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCSNFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbgCSNFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:05:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5062620740;
        Thu, 19 Mar 2020 13:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623148;
        bh=5vB8mUdyw2isuB6lmMYIy2+5uMEcnHqGLYk6HsSd1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjwpMbqV56P2xpmpxbP19bZ7BdAcT+JQhUcqfWq24xpMo4Oae+UrcVBh2ixSuKkVO
         GhNRQYYhYz+fcgk1jfW0ANmeJRlp6z52rcdufa5qdjtmEyjTfdBAD/fhYQcTGWyRXA
         tyd03reJguYa3wOixWQED7pOcao6Bi8bSvyAyfrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.4 24/93] gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache
Date:   Thu, 19 Mar 2020 13:59:28 +0100
Message-Id: <20200319123932.723472468@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
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
@@ -1245,7 +1245,7 @@ static int gfs2_atomic_open(struct inode
 		if (!(*opened & FILE_OPENED))
 			return finish_no_open(file, d);
 		dput(d);
-		return 0;
+		return excl && (flags & O_CREAT) ? -EEXIST : 0;
 	}
 
 	BUG_ON(d != NULL);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F0E187F20
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCQK6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgCQK6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:58:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D77ED20724;
        Tue, 17 Mar 2020 10:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442726;
        bh=UzxYSHzk2tW0gJ25zVESWN3tdPqPC6wHiWDbCCRoygE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4aquv8i9TuTui3I1c3SceAL+vlPOfH8b6yEhPKbZAkb1Q0M6l37F2Nx636ZP9EmB
         5znYyHAYRLDsGj3CUbU46ClzQ8zQgzel7nS5nl+cIdXMMs18/af418/kBma8Rut9io
         OrmPK239eggTYzf7MJm12SmmWxEqMiej2+YbN00E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.19 59/89] gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache
Date:   Tue, 17 Mar 2020 11:55:08 +0100
Message-Id: <20200317103306.676904167@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
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
@@ -1251,7 +1251,7 @@ static int gfs2_atomic_open(struct inode
 		if (!(file->f_mode & FMODE_OPENED))
 			return finish_no_open(file, d);
 		dput(d);
-		return 0;
+		return excl && (flags & O_CREAT) ? -EEXIST : 0;
 	}
 
 	BUG_ON(d != NULL);



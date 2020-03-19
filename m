Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEC1918B4C2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCSNMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbgCSNMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:12:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10466214D8;
        Thu, 19 Mar 2020 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623543;
        bh=gshXoy1Vsgwe1/X1ljL9vo8JPm80oVkJvWWSclvaRM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eF8XE5rn2HbRhd09cflKjaUlBn3lNT5Y1vB6vHPfQLzw+NQE57of2B7pmSS8Ib7Fh
         iJgkk21H5CD9uuyQNf6aoQ86VAFa8mO4G442ETm60OCskNQXdDkmnWUzE5GvxR/uBx
         h6Ssoku7tz8pSCWtc2WLlffRf9zsRzg40qlQBfTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.9 36/90] gfs2_atomic_open(): fix O_EXCL|O_CREAT handling on cold dcache
Date:   Thu, 19 Mar 2020 13:59:58 +0100
Message-Id: <20200319123939.831610471@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
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
@@ -1248,7 +1248,7 @@ static int gfs2_atomic_open(struct inode
 		if (!(*opened & FILE_OPENED))
 			return finish_no_open(file, d);
 		dput(d);
-		return 0;
+		return excl && (flags & O_CREAT) ? -EEXIST : 0;
 	}
 
 	BUG_ON(d != NULL);



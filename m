Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648D42A580F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbgKCVrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731002AbgKCUut (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715C022404;
        Tue,  3 Nov 2020 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436648;
        bh=P6PU9YgYPvKsSgsFwFUTvABFrFkeAW6iIYmJKiRzi94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDnlges5PXrN/ydr+NNo0xZMHIv+fO88zcLbcp6phou5HkcmXwHq4CGBmmAspsNEx
         lzYNiQDThBh37QIBRmbxPHI6XV5rXvQ2/JxJbwzxOMyWmpkpgcV231/ayPJFv6eb8B
         1zH1oxC3UPyM1zF1kEGNluj+nCB3p87pQlV/QFAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Kristof Havasi <havasiefr@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.9 305/391] ubifs: journal: Make sure to not dirty twice for auth nodes
Date:   Tue,  3 Nov 2020 21:35:56 +0100
Message-Id: <20201103203407.681366424@linuxfoundation.org>
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

From: Richard Weinberger <richard@nod.at>

commit 78c7d49f55d8631b67c09f9bfbe8155211a9ea06 upstream.

When removing the last reference of an inode the size of an auth node
is already part of write_len. So we must not call ubifs_add_auth_dirt().
Call it only when needed.

Cc: <stable@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Kristof Havasi <havasiefr@gmail.com>
Fixes: 6a98bc4614de ("ubifs: Add authentication nodes to journal")
Reported-and-tested-by: Kristof Havasi <havasiefr@gmail.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/journal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -938,8 +938,6 @@ int ubifs_jnl_write_inode(struct ubifs_i
 					  inode->i_ino);
 	release_head(c, BASEHD);
 
-	ubifs_add_auth_dirt(c, lnum);
-
 	if (last_reference) {
 		err = ubifs_tnc_remove_ino(c, inode->i_ino);
 		if (err)
@@ -949,6 +947,8 @@ int ubifs_jnl_write_inode(struct ubifs_i
 	} else {
 		union ubifs_key key;
 
+		ubifs_add_auth_dirt(c, lnum);
+
 		ino_key_init(c, &key, inode->i_ino);
 		err = ubifs_tnc_add(c, &key, lnum, offs, ilen, hash);
 	}



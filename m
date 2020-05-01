Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E871C144A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgEANhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgEANhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:37:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93DDB2495A;
        Fri,  1 May 2020 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340270;
        bh=wbTdBVJuZ2QGIL3DoE3RkbBh6BRtM0pmebWeNOoD6qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwKYePrPlJvKqpXmjNBKGDKbeu32QL35ISdF1N7P8MIMjPdGYKRUyBrydojwRu7dq
         1ms5aD8iUCiQKzpkc4IbJOEQTtVYkgAIN+LNr6d5PwvxPy94uYVWX+pBW5f/bu+Imn
         1tG0g67tBH24QXJT4J8bDcanYOP95O1+5EOjja8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=D0=9A=D0=BE=D1=87=D0=B5=D1=82=D0=BA=D0=BE=D0=B2=20=D0=9C=D0=B0=D0=BA=D1=81=D0=B8=D0=BC?= 
        <fido_max@inbox.ru>, Karl Olsen <karl@micro-technic.com>,
        Jef Driesen <jef.driesen@niko.eu>,
        Richard Weinberger <richard@nod.at>,
        Christian Eggers <ceggers@arri.de>,
        "Christian Berger" <Christian.Berger@de.bosch.com>
Subject: [PATCH 5.4 02/83] ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()
Date:   Fri,  1 May 2020 15:22:41 +0200
Message-Id: <20200501131524.703958316@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit 4ab25ac8b2b5514151d5f91cf9514df08dd26938 upstream.

Orphans are allowed to point to deleted inodes.
So -ENOENT is not a fatal error.

Reported-by: Кочетков Максим <fido_max@inbox.ru>
Reported-and-tested-by: "Christian Berger" <Christian.Berger@de.bosch.com>
Tested-by: Karl Olsen <karl@micro-technic.com>
Tested-by: Jef Driesen <jef.driesen@niko.eu>
Fixes: ee1438ce5dc4 ("ubifs: Check link count of inodes when killing orphans.")
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Christian Eggers <ceggers@arri.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -688,14 +688,14 @@ static int do_kill_orphans(struct ubifs_
 
 			ino_key_init(c, &key1, inum);
 			err = ubifs_tnc_lookup(c, &key1, ino);
-			if (err)
+			if (err && err != -ENOENT)
 				goto out_free;
 
 			/*
 			 * Check whether an inode can really get deleted.
 			 * linkat() with O_TMPFILE allows rebirth of an inode.
 			 */
-			if (ino->nlink == 0) {
+			if (err == 0 && ino->nlink == 0) {
 				dbg_rcvry("deleting orphaned inode %lu",
 					  (unsigned long)inum);
 



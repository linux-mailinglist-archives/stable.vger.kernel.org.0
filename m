Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2203F10BB82
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbfK0VNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732929AbfK0VNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:13:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDAC12154A;
        Wed, 27 Nov 2019 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889197;
        bh=m+9gLKLJPVKmbMVfTrjUnkZTGNhO4OvqC2oDE5gvC5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKtRZVRPTplDnoujuYT0+Oph/LsRl5SEs0QdLQ/r05Llo6zTJnwMqSf7cken7wCMg
         ukBBgVPdVBk8xWWfx00jST4HMQarfue7gVW7KBvVgWU0b/gLeq5WN16NjkBZfMEOC1
         kxUBfBUZY0axLyyGZqIh9GwW7eLDjC2zgBO1W15Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Pittman <jpittman@redhat.com>,
        David Jeffery <djeffery@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 08/66] md/raid10: prevent access of uninitialized resync_pages offset
Date:   Wed, 27 Nov 2019 21:32:03 +0100
Message-Id: <20191127202644.311484265@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Pittman <jpittman@redhat.com>

commit 45422b704db392a6d79d07ee3e3670b11048bd53 upstream.

Due to unneeded multiplication in the out_free_pages portion of
r10buf_pool_alloc(), when using a 3-copy raid10 layout, it is
possible to access a resync_pages offset that has not been
initialized.  This access translates into a crash of the system
within resync_free_pages() while passing a bad pointer to
put_page().  Remove the multiplication, preventing access to the
uninitialized area.

Fixes: f0250618361db ("md: raid10: don't use bio's vec table to manage resync pages")
Cc: stable@vger.kernel.org # 4.12+
Signed-off-by: John Pittman <jpittman@redhat.com>
Suggested-by: David Jeffery <djeffery@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -191,7 +191,7 @@ static void * r10buf_pool_alloc(gfp_t gf
 
 out_free_pages:
 	while (--j >= 0)
-		resync_free_pages(&rps[j * 2]);
+		resync_free_pages(&rps[j]);
 
 	j = 0;
 out_free_bio:



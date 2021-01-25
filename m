Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5D8304A7B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbhAZFEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731298AbhAYSxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 236F7224BE;
        Mon, 25 Jan 2021 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600819;
        bh=DVs/Hsq1dMmzP/4IIndLl33tcW4RfiE+yYR4fA+0KTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfTsyPlLTA6OHXSY7tzmNsJImK6OH0Xau//Z/wrdoapb5PC7Co5fF3QBkLePiHd0B
         rjVLP2SrVlwTdJ0zhjmnA6tJrqevMELU9uVrzuTxeQaGOem1FTTvaowK2S9brpTbhX
         WfeSvm/iHzHh9Bcn90QVq8/itddQBXTiSgObBl6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        David Howells <dhowells@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 164/199] cachefiles: Drop superfluous readpages aops NULL check
Date:   Mon, 25 Jan 2021 19:39:46 +0100
Message-Id: <20210125183223.118213615@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit db58465f1121086b524be80be39d1fedbe5387f3 upstream.

After the recent actions to convert readpages aops to readahead, the
NULL checks of readpages aops in cachefiles_read_or_alloc_page() may
hit falsely.  More badly, it's an ASSERT() call, and this panics.

Drop the superfluous NULL checks for fixing this regression.

[DH: Note that cachefiles never actually used readpages, so this check was
 never actually necessary]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208883
BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1175245
Fixes: 9ae326a69004 ("CacheFiles: A cache that backs onto a mounted filesystem")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cachefiles/rdwr.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -413,7 +413,6 @@ int cachefiles_read_or_alloc_page(struct
 
 	inode = d_backing_inode(object->backer);
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->readpages);
 
 	/* calculate the shift required to use bmap */
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;
@@ -713,7 +712,6 @@ int cachefiles_read_or_alloc_pages(struc
 
 	inode = d_backing_inode(object->backer);
 	ASSERT(S_ISREG(inode->i_mode));
-	ASSERT(inode->i_mapping->a_ops->readpages);
 
 	/* calculate the shift required to use bmap */
 	shift = PAGE_SHIFT - inode->i_sb->s_blocksize_bits;



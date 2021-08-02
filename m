Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3613DDA35
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235897AbhHBOHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237854AbhHBOFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 904456124C;
        Mon,  2 Aug 2021 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912699;
        bh=CwkRCANt2YDAhNZ1Yxv2SmEpwFcFZxmCXUlNM8tEypA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkvDr4CFJZxzcWt4i/4eE9bFaBIrfx2KEdqM2Ip3GvbWtnR9a0U1t30IOBt58LNDF
         ClR75HDM2lshQCMpiuFC/Mi6JzoL1uzNeCOA7yv7KEdg+HbhJREVOQMJHt30z0OLF7
         c2EQ5/rr8SLaWSfLNin4btzBXhAyWm96zK1IMbm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.13 096/104] SMB3: fix readpage for large swap cache
Date:   Mon,  2 Aug 2021 15:45:33 +0200
Message-Id: <20210802134347.163046996@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit f2a26a3cff27dfa456fef386fe5df56dcb4b47b6 upstream.

readpage was calculating the offset of the page incorrectly
for the case of large swapcaches.

    loff_t offset = (loff_t)page->index << PAGE_SHIFT;

As pointed out by Matthew Wilcox, this needs to use
page_file_offset() to calculate the offset instead.
Pages coming from the swap cache have page->index set
to their index within the swapcache, not within the backing
file.  For a sufficiently large swapcache, we could have
overlapping values of page->index within the same backing file.

Suggested by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4631,7 +4631,7 @@ read_complete:
 
 static int cifs_readpage(struct file *file, struct page *page)
 {
-	loff_t offset = (loff_t)page->index << PAGE_SHIFT;
+	loff_t offset = page_file_offset(page);
 	int rc = -EACCES;
 	unsigned int xid;
 



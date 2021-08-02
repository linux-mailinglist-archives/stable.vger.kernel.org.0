Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6C43DD92A
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhHBN5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235600AbhHBNzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B0361029;
        Mon,  2 Aug 2021 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912463;
        bh=ZV2hSBD6E0EMrljNMWUKPSSrm3XvbDMmhatlErAp7ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NE63Gbce+xrHfWwGbImFGehd9J60dx6cubImD6+G0xzDJYCudBa1UEO4LzNtHwiE2
         Y7w+P8yfMaBSU3U4qhlSxQPTN7deFWEG5UKvTAd8pjGh/H0IzgwayJUZ+Dp0bgwYid
         lkuLW3rVtQWYTBHE/orPIZfUKPOflgA42apRHp1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 63/67] SMB3: fix readpage for large swap cache
Date:   Mon,  2 Aug 2021 15:45:26 +0200
Message-Id: <20210802134341.204392949@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
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
@@ -4550,7 +4550,7 @@ read_complete:
 
 static int cifs_readpage(struct file *file, struct page *page)
 {
-	loff_t offset = (loff_t)page->index << PAGE_SHIFT;
+	loff_t offset = page_file_offset(page);
 	int rc = -EACCES;
 	unsigned int xid;
 



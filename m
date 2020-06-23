Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10B1206072
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392468AbgFWUm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392465AbgFWUm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5E362070E;
        Tue, 23 Jun 2020 20:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944977;
        bh=EEWGFIUWt643IFNaKOFYAZVIQZJxmAKypLrHFL18Eb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2XAYjqbvoZvffQMIYKhavZ8RJDoiJYlDv2iW8dfttcjiIQYHxFZYIQ0ePjsccKbN
         32mdYr3QNpsS0yq+apwsKz9cH2W29ZTuj5ZOMIdqsaDcwY65v4s09aN9ZN1XpYqIpD
         8HRO4VKqkeCm482zlMb00lIbD4KGXHnFBuT9sYPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/206] afs: Fix non-setting of mtime when writing into mmap
Date:   Tue, 23 Jun 2020 21:58:16 +0200
Message-Id: <20200623195325.281409856@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit bb413489288e4e457353bac513fddb6330d245ca ]

The mtime on an inode needs to be updated when a write is made into an
mmap'ed section.  There are three ways in which this could be done: update
it when page_mkwrite is called, update it when a page is changed from dirty
to writeback or leave it to the server and fix the mtime up from the reply
to the StoreData RPC.

Found with the generic/215 xfstest.

Fixes: 1cf7a1518aef ("afs: Implement shared-writeable mmap")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index e00461a6de9aa..53f329f61cc37 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -792,6 +792,7 @@ vm_fault_t afs_page_mkwrite(struct vm_fault *vmf)
 			     vmf->page->index, priv);
 	SetPagePrivate(vmf->page);
 	set_page_private(vmf->page, priv);
+	file_update_time(file);
 
 	sb_end_pagefault(inode->i_sb);
 	return VM_FAULT_LOCKED;
-- 
2.25.1




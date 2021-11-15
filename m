Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D965845222A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhKPBKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245016AbhKOTSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CEA66343F;
        Mon, 15 Nov 2021 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000828;
        bh=HT2sO5kkxAjD3LrXmop1FXCyyhrfpkVc6O8n7LDbXBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnHcWkGnCxexk5eYB1HpDUiN1Z+NJyMXQPnYFSKX/E2QJifkjmXRfhKGbeWz7N9qw
         Y+rTRw63FkED5cnIzk7O5te513zHRZ347MV3+EhKKImgeZeyXtnNXQLKS5DR9gnioT
         An/0Hv0cOGvJ2eT36rZBMb2oi4ngYckzTVqWa0yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 807/849] mm/filemap.c: remove bogus VM_BUG_ON
Date:   Mon, 15 Nov 2021 18:04:50 +0100
Message-Id: <20211115165447.538673380@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit d417b49fff3e2f21043c834841e8623a6098741d upstream.

It is not safe to check page->index without holding the page lock.  It
can be changed if the page is moved between the swap cache and the page
cache for a shmem file, for example.  There is a VM_BUG_ON below which
checks page->index is correct after taking the page lock.

Link: https://lkml.kernel.org/r/20210818144932.940640-1-willy@infradead.org
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: <syzbot+c87be4f669d920c76330@syzkaller.appspotmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2038,7 +2038,6 @@ unsigned find_lock_entries(struct addres
 		if (!xa_is_value(page)) {
 			if (page->index < start)
 				goto put;
-			VM_BUG_ON_PAGE(page->index != xas.xa_index, page);
 			if (page->index + thp_nr_pages(page) - 1 > end)
 				goto put;
 			if (!trylock_page(page))



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B349E420D83
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbhJDNP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235590AbhJDNN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:13:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFFF261BA1;
        Mon,  4 Oct 2021 13:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352734;
        bh=vqWyOeURbVSKl5y9uVz/VN+k2c77rNz1w9AaZ81FS7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wH3/izxR5kOcmnKpUwdhhB86EUDL1/EAENCNctUI+VJdMAaSz+nKyGybYAr6oL3d7
         m14h0d0ipdykWI1V9yvfxWw0x+Qmalulq4qvE/BEswtXI1sP8EfLxA1/M/ZKAncKUd
         Nwvoe+tNV29RH0CVqa/yNREc23xMMw/9Bdtl4M3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com,
        syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com,
        syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 93/95] netfilter: ipset: Fix oversized kvmalloc() calls
Date:   Mon,  4 Oct 2021 14:53:03 +0200
Message-Id: <20211004125036.606912734@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

commit 7bbc3d385bd813077acaf0e6fdb2a86a901f5382 upstream.

The commit

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 09:45:49 2021 -0700

    mm: don't allow oversized kvmalloc() calls

limits the max allocatable memory via kvmalloc() to MAX_INT. Apply the
same limit in ipset.

Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
Reported-by: syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com
Reported-by: syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -104,11 +104,11 @@ htable_size(u8 hbits)
 {
 	size_t hsize;
 
-	/* We must fit both into u32 in jhash and size_t */
+	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
+	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 



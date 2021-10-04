Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41F421072
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhJDNoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238683AbhJDNmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE9B6325E;
        Mon,  4 Oct 2021 13:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353569;
        bh=X/ptOpXz0zVL/f5EkXAzeEEizI0Woco8mDP2WaV85gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9BCLGkjQIDdkvtTzzwkqdE3C0rgGe2KglKwbbA5I9YSYO6LXqLP0wYfgk1KCuPdo
         RmgEePCZyHX9Mdl0RkS0CuEjscOhKU0yUYAO+yWY1lD1Qze6b9j/iow6ONl4ZP1Dpi
         1w7FaUAGr5MQ2BvdhTc4wFGzWS63BeDIcvXbb72o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com,
        syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com,
        syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.14 164/172] netfilter: ipset: Fix oversized kvmalloc() calls
Date:   Mon,  4 Oct 2021 14:53:34 +0200
Message-Id: <20211004125050.268507665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
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
@@ -130,11 +130,11 @@ htable_size(u8 hbits)
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
 



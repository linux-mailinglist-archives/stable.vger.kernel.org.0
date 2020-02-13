Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C284C15C330
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbgBMP2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387741AbgBMP2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:37 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03D2524671;
        Thu, 13 Feb 2020 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607717;
        bh=IrTAExo0GMcygchAtn0puJ0Ay//ICD8FkZHzXTXCYGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSc4b71OsQVcNRQEXzQv3M5bT3Zma7yhMZAk1Z2NPKfuCC5XkcjqX0LCnXUq+bMGs
         QPb0rGAcAGCWvnmCKFlxp5eNOBt1eC+DBzpy6JeZzcfDp9ck54hSQVuD6O/i3hlZt8
         aVVo2m2WBeiijfctlB97SB7opqLBT1Nq4gn+B9Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.5 040/120] bpf: Improve bucket_log calculation logic
Date:   Thu, 13 Feb 2020 07:20:36 -0800
Message-Id: <20200213151915.467031893@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

commit 88d6f130e5632bbf419a2e184ec7adcbe241260b upstream.

It was reported that the max_t, ilog2, and roundup_pow_of_two macros have
exponential effects on the number of states in the sparse checker.

This patch breaks them up by calculating the "nbuckets" first so that the
"bucket_log" only needs to take ilog2().

In addition, Linus mentioned:

  Patch looks good, but I'd like to point out that it's not just sparse.

  You can see it with a simple

    make net/core/bpf_sk_storage.i
    grep 'smap->bucket_log = ' net/core/bpf_sk_storage.i | wc

  and see the end result:

      1  365071 2686974

  That's one line (the assignment line) that is 2,686,974 characters in
  length.

  Now, sparse does happen to react particularly badly to that (I didn't
  look to why, but I suspect it's just that evaluating all the types
  that don't actually ever end up getting used ends up being much more
  expensive than it should be), but I bet it's not good for gcc either.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Link: https://lore.kernel.org/bpf/20200207081810.3918919-1-kafai@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/bpf_sk_storage.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -643,9 +643,10 @@ static struct bpf_map *bpf_sk_storage_ma
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
 
+	nbuckets = roundup_pow_of_two(num_possible_cpus());
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1 bucket */
-	smap->bucket_log = max_t(u32, 1, ilog2(roundup_pow_of_two(num_possible_cpus())));
-	nbuckets = 1U << smap->bucket_log;
+	nbuckets = max_t(u32, 2, nbuckets);
+	smap->bucket_log = ilog2(nbuckets);
 	cost = sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
 
 	ret = bpf_map_charge_init(&smap->map.memory, cost);



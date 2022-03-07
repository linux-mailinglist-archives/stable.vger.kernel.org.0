Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880D64CFA56
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiCGKPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241450AbiCGKKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9917A2E6B7;
        Mon,  7 Mar 2022 01:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C427B80F9F;
        Mon,  7 Mar 2022 09:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFB6C340F4;
        Mon,  7 Mar 2022 09:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646783;
        bh=jL18z2hE6xJ6jALu7cW0FPYndfKRVk1ejDkLHHhGj0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQYhpqp7rjij5Cy08lDbuC6OzYtgcDnexHFbKbLNBC2FnGjjaR1oxAkb9S67A9rLe
         tfurYkgXVpg+ooc1OWMlgKSZADh0ZBAf4mz3JLrWK3OwPrqwTtre/n4ozhQKvkPBtC
         RZlPfOUwohY8IbcaCAuu0NuXKZvBurPmO5s+kkDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Willy Tarreau <w@1wt.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 5.16 065/186] mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls
Date:   Mon,  7 Mar 2022 10:18:23 +0100
Message-Id: <20220307091655.911194324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 0708a0afe291bdfe1386d74d5ec1f0c27e8b9168 upstream.

syzkaller was recently triggering an oversized kvmalloc() warning via
xdp_umem_create().

The triggered warning was added back in 7661809d493b ("mm: don't allow
oversized kvmalloc() calls"). The rationale for the warning for huge
kvmalloc sizes was as a reaction to a security bug where the size was
more than UINT_MAX but not everything was prepared to handle unsigned
long sizes.

Anyway, the AF_XDP related call trace from this syzkaller report was:

  kvmalloc include/linux/mm.h:806 [inline]
  kvmalloc_array include/linux/mm.h:824 [inline]
  kvcalloc include/linux/mm.h:829 [inline]
  xdp_umem_pin_pages net/xdp/xdp_umem.c:102 [inline]
  xdp_umem_reg net/xdp/xdp_umem.c:219 [inline]
  xdp_umem_create+0x6a5/0xf00 net/xdp/xdp_umem.c:252
  xsk_setsockopt+0x604/0x790 net/xdp/xsk.c:1068
  __sys_setsockopt+0x1fd/0x4e0 net/socket.c:2176
  __do_sys_setsockopt net/socket.c:2187 [inline]
  __se_sys_setsockopt net/socket.c:2184 [inline]
  __x64_sys_setsockopt+0xb5/0x150 net/socket.c:2184
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Björn mentioned that requests for >2GB allocation can still be valid:

  The structure that is being allocated is the page-pinning accounting.
  AF_XDP has an internal limit of U32_MAX pages, which is *a lot*, but
  still fewer than what memcg allows (PAGE_COUNTER_MAX is a LONG_MAX/
  PAGE_SIZE on 64 bit systems). [...]

  I could just change from U32_MAX to INT_MAX, but as I stated earlier
  that has a hacky feeling to it. [...] From my perspective, the code
  isn't broken, with the memcg limits in consideration. [...]

Linus says:

  [...] Pretty much every time this has come up, the kernel warning has
  shown that yes, the code was broken and there really wasn't a reason
  for doing allocations that big.

  Of course, some people would be perfectly fine with the allocation
  failing, they just don't want the warning. I didn't want __GFP_NOWARN
  to shut it up originally because I wanted people to see all those
  cases, but these days I think we can just say "yeah, people can shut
  it up explicitly by saying 'go ahead and fail this allocation, don't
  warn about it'".

  So enough time has passed that by now I'd certainly be ok with [it].

Thus allow call-sites to silence such userspace triggered splats if the
allocation requests have __GFP_NOWARN. For xdp_umem_pin_pages()'s call
to kvcalloc() this is already the case, so nothing else needed there.

Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
Reported-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/bpf/CAJ+HfNhyfsT5cS_U9EC213ducHs9k9zNxX9+abqC0kTrPbQ0gg@mail.gmail.com
Link: https://lore.kernel.org/bpf/20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Ackd-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/util.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -594,8 +594,10 @@ void *kvmalloc_node(size_t size, gfp_t f
 		return ret;
 
 	/* Don't even allow crazy sizes */
-	if (WARN_ON_ONCE(size > INT_MAX))
+	if (unlikely(size > INT_MAX)) {
+		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
 		return NULL;
+	}
 
 	return __vmalloc_node(size, 1, flags, node,
 			__builtin_return_address(0));



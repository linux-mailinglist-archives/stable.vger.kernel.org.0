Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7146059D42F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbiHWIWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243431AbiHWIVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E3B6EF30;
        Tue, 23 Aug 2022 01:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F84EB81C3B;
        Tue, 23 Aug 2022 08:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634CEC433D6;
        Tue, 23 Aug 2022 08:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242342;
        bh=z+CGCDyFSMPbd/EN3DNknlU9RDhJkyHosZULARlSM94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPUN3aFZXheTy8L+51Vm+bKgM7oCOoM5UuuYJUOk8/DY5IfkeomfFmdxWaoJYIkxs
         oiLPPnmKqenYDXibY9XV8yA8SZYldOrQpTi7MhkBDOeB5YlIHdsDEENyezCqXgzLD2
         i1qS8y2L5rAuQYt5uCAwwsXqh7bFwg3KB/LWsjuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.19 063/365] bpf: Dont reinit map value in prealloc_lru_pop
Date:   Tue, 23 Aug 2022 09:59:24 +0200
Message-Id: <20220823080120.831080541@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 275c30bcee66a27d1aa97a215d607ad6d49804cb upstream.

The LRU map that is preallocated may have its elements reused while
another program holds a pointer to it from bpf_map_lookup_elem. Hence,
only check_and_free_fields is appropriate when the element is being
deleted, as it ensures proper synchronization against concurrent access
of the map value. After that, we cannot call check_and_init_map_value
again as it may rewrite bpf_spin_lock, bpf_timer, and kptr fields while
they can be concurrently accessed from a BPF program.

This is safe to do as when the map entry is deleted, concurrent access
is protected against by check_and_free_fields, i.e. an existing timer
would be freed, and any existing kptr will be released by it. The
program can create further timers and kptrs after check_and_free_fields,
but they will eventually be released once the preallocated items are
freed on map destruction, even if the item is never reused again. Hence,
the deleted item sitting in the free list can still have resources
attached to it, and they would never leak.

With spin_lock, we never touch the field at all on delete or update, as
we may end up modifying the state of the lock. Since the verifier
ensures that a bpf_spin_lock call is always paired with bpf_spin_unlock
call, the program will eventually release the lock so that on reuse the
new user of the value can take the lock.

Essentially, for the preallocated case, we must assume that the map
value may always be in use by the program, even when it is sitting in
the freelist, and handle things accordingly, i.e. use proper
synchronization inside check_and_free_fields, and never reinitialize the
special fields when it is reused on update.

Fixes: 68134668c17f ("bpf: Add map side support for bpf timers.")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/r/20220809213033.24147-3-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/hashtab.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -311,12 +311,8 @@ static struct htab_elem *prealloc_lru_po
 	struct htab_elem *l;
 
 	if (node) {
-		u32 key_size = htab->map.key_size;
-
 		l = container_of(node, struct htab_elem, lru_node);
-		memcpy(l->key, key, key_size);
-		check_and_init_map_value(&htab->map,
-					 l->key + round_up(key_size, 8));
+		memcpy(l->key, key, htab->map.key_size);
 		return l;
 	}
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDF64C76A3
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiB1SFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbiB1SCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:02:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F7F9D0ED;
        Mon, 28 Feb 2022 09:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D51B815CE;
        Mon, 28 Feb 2022 17:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F26C36AF6;
        Mon, 28 Feb 2022 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070350;
        bh=Y0buiqhGATpeWfTeTQqEm7d8nnRXUVLoevG30zJT4+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkkAeevZPq7e2c6rwpmv+fQ36mAC0k9I7KxqRJJlfrYOf/cJ0yPuPQYcvuJwKU1Oq
         X2JlKSCHqi2E6zBDiEyaBM166N5kgi14SaP9O65KfhO58mhF0YJDQffadY/VUdvcbZ
         AhjI6ch+9n+LSrxxg64PM/ZmzqASFLINsbP7S/xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.16 059/164] bpf: Fix a bpf_timer initialization issue
Date:   Mon, 28 Feb 2022 18:23:41 +0100
Message-Id: <20220228172405.514703207@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit 5eaed6eedbe9612f642ad2b880f961d1c6c8ec2b upstream.

The patch in [1] intends to fix a bpf_timer related issue,
but the fix caused existing 'timer' selftest to fail with
hang or some random errors. After some debug, I found
an issue with check_and_init_map_value() in the hashtab.c.
More specifically, in hashtab.c, we have code
  l_new = bpf_map_kmalloc_node(&htab->map, ...)
  check_and_init_map_value(&htab->map, l_new...)
Note that bpf_map_kmalloc_node() does not do initialization
so l_new contains random value.

The function check_and_init_map_value() intends to zero the
bpf_spin_lock and bpf_timer if they exist in the map.
But I found bpf_spin_lock is zero'ed but bpf_timer is not zero'ed.
With [1], later copy_map_value() skips copying of
bpf_spin_lock and bpf_timer. The non-zero bpf_timer caused
random failures for 'timer' selftest.
Without [1], for both bpf_spin_lock and bpf_timer case,
bpf_timer will be zero'ed, so 'timer' self test is okay.

For check_and_init_map_value(), why bpf_spin_lock is zero'ed
properly while bpf_timer not. In bpf uapi header, we have
  struct bpf_spin_lock {
        __u32   val;
  };
  struct bpf_timer {
        __u64 :64;
        __u64 :64;
  } __attribute__((aligned(8)));

The initialization code:
  *(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
      (struct bpf_spin_lock){};
  *(struct bpf_timer *)(dst + map->timer_off) =
      (struct bpf_timer){};
It appears the compiler has no obligation to initialize anonymous fields.
For example, let us use clang with bpf target as below:
  $ cat t.c
  struct bpf_timer {
        unsigned long long :64;
  };
  struct bpf_timer2 {
        unsigned long long a;
  };

  void test(struct bpf_timer *t) {
    *t = (struct bpf_timer){};
  }
  void test2(struct bpf_timer2 *t) {
    *t = (struct bpf_timer2){};
  }
  $ clang -target bpf -O2 -c -g t.c
  $ llvm-objdump -d t.o
   ...
   0000000000000000 <test>:
       0:       95 00 00 00 00 00 00 00 exit
   0000000000000008 <test2>:
       1:       b7 02 00 00 00 00 00 00 r2 = 0
       2:       7b 21 00 00 00 00 00 00 *(u64 *)(r1 + 0) = r2
       3:       95 00 00 00 00 00 00 00 exit

gcc11.2 does not have the above issue. But from
  INTERNATIONAL STANDARD ©ISO/IEC ISO/IEC 9899:201x
  Programming languages — C
  http://www.open-std.org/Jtc1/sc22/wg14/www/docs/n1547.pdf
  page 157:
  Except where explicitly stated otherwise, for the purposes of
  this subclause unnamed members of objects of structure and union
  type do not participate in initialization. Unnamed members of
  structure objects have indeterminate value even after initialization.

To fix the problem, let use memset for bpf_timer case in
check_and_init_map_value(). For consistency, memset is also
used for bpf_spin_lock case.

  [1] https://lore.kernel.org/bpf/20220209070324.1093182-2-memxor@gmail.com/

Fixes: 68134668c17f3 ("bpf: Add map side support for bpf timers.")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220211194953.3142152-1-yhs@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -209,11 +209,9 @@ static inline bool map_value_has_timer(c
 static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 {
 	if (unlikely(map_value_has_spin_lock(map)))
-		*(struct bpf_spin_lock *)(dst + map->spin_lock_off) =
-			(struct bpf_spin_lock){};
+		memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
 	if (unlikely(map_value_has_timer(map)))
-		*(struct bpf_timer *)(dst + map->timer_off) =
-			(struct bpf_timer){};
+		memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
 }
 
 /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */



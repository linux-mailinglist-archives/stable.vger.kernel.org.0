Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508D15B7363
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiIMPIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiIMPHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:07:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F422E696FF;
        Tue, 13 Sep 2022 07:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95309614E9;
        Tue, 13 Sep 2022 14:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9A0C433D7;
        Tue, 13 Sep 2022 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079451;
        bh=4q8krE1FsncwNTfSC0uky0pPAGgOhmkWebSZonlFBbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaafyqCvDfx5/Ji7aBxIN32Cdx4ZD+ILGnHsShYenW/Uw+eGnArBZgT2S6EB27z+Y
         B8yETRyUMu3egwJ3W1NNXkichgzZXAfqOn2J99qJWR7td+J6IrOIePSE+NJwdqGpiv
         JGfmusZkaduh9tBM8xWo/HrDSH8Z9Mw7gwbwZ8b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Fengwei Yin <fengwei.yin@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 05/79] fs: only do a memory barrier for the first set_buffer_uptodate()
Date:   Tue, 13 Sep 2022 16:06:23 +0200
Message-Id: <20220913140349.115062208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2f79cdfe58c13949bbbb65ba5926abfe9561d0ec upstream.

Commit d4252071b97d ("add barriers to buffer_uptodate and
set_buffer_uptodate") added proper memory barriers to the buffer head
BH_Uptodate bit, so that anybody who tests a buffer for being up-to-date
will be guaranteed to actually see initialized state.

However, that commit didn't _just_ add the memory barrier, it also ended
up dropping the "was it already set" logic that the BUFFER_FNS() macro
had.

That's conceptually the right thing for a generic "this is a memory
barrier" operation, but in the case of the buffer contents, we really
only care about the memory barrier for the _first_ time we set the bit,
in that the only memory ordering protection we need is to avoid anybody
seeing uninitialized memory contents.

Any other access ordering wouldn't be about the BH_Uptodate bit anyway,
and would require some other proper lock (typically BH_Lock or the folio
lock).  A reader that races with somebody invalidating the buffer head
isn't an issue wrt the memory ordering, it's a serialization issue.

Now, you'd think that the buffer head operations don't matter in this
day and age (and I certainly thought so), but apparently some loads
still end up being heavy users of buffer heads.  In particular, the
kernel test robot reported that not having this bit access optimization
in place caused a noticeable direct IO performance regression on ext4:

  fxmark.ssd_ext4_no_jnl_DWTL_54_directio.works/sec -26.5% regression

although you presumably need a fast disk and a lot of cores to actually
notice.

Link: https://lore.kernel.org/all/Yw8L7HTZ%2FdE2%2Fo9C@xsang-OptiPlex-9020/
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Fengwei Yin <fengwei.yin@intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/buffer_head.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -137,6 +137,17 @@ BUFFER_FNS(Defer_Completion, defer_compl
 static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
 {
 	/*
+	 * If somebody else already set this uptodate, they will
+	 * have done the memory barrier, and a reader will thus
+	 * see *some* valid buffer state.
+	 *
+	 * Any other serialization (with IO errors or whatever that
+	 * might clear the bit) has to come from other state (eg BH_Lock).
+	 */
+	if (test_bit(BH_Uptodate, &bh->b_state))
+		return;
+
+	/*
 	 * make it consistent with folio_mark_uptodate
 	 * pairs with smp_load_acquire in buffer_uptodate
 	 */



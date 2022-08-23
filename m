Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA359DCFA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357243AbiHWLKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344795AbiHWLJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:09:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4BC754AA;
        Tue, 23 Aug 2022 02:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A70DDB8105C;
        Tue, 23 Aug 2022 09:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D97AC433C1;
        Tue, 23 Aug 2022 09:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246200;
        bh=qpyjHBlNmvh5qz8ZjsmPzt6EGeEiWMCvxwoRJDS94vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCqGx5NFbIWk94AC7VJxIqH1A+rI+fkmk67Z5kjlO3+axjOmbDB4xwc6/w7vfx6EU
         bcQNeNnXtK4/eL8Yzwz59OfKd4GJJ2oCnLmnPXapDpRs5u7RuVidENvO37Gb6BxstQ
         gltscHNB2eKiiChOn/f6fdtZC42VADWsgw7LHbHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 009/389] add barriers to buffer_uptodate and set_buffer_uptodate
Date:   Tue, 23 Aug 2022 10:21:27 +0200
Message-Id: <20220823080116.046249849@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit d4252071b97d2027d246f6a82cbee4d52f618b47 upstream.

Let's have a look at this piece of code in __bread_slow:

	get_bh(bh);
	bh->b_end_io = end_buffer_read_sync;
	submit_bh(REQ_OP_READ, 0, bh);
	wait_on_buffer(bh);
	if (buffer_uptodate(bh))
		return bh;

Neither wait_on_buffer nor buffer_uptodate contain any memory barrier.
Consequently, if someone calls sb_bread and then reads the buffer data,
the read of buffer data may be executed before wait_on_buffer(bh) on
architectures with weak memory ordering and it may return invalid data.

Fix this bug by adding a memory barrier to set_buffer_uptodate and an
acquire barrier to buffer_uptodate (in a similar way as
folio_test_uptodate and folio_mark_uptodate).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/buffer_head.h |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -117,7 +117,6 @@ static __always_inline int test_clear_bu
  * of the form "mark_buffer_foo()".  These are higher-level functions which
  * do something in addition to setting a b_state bit.
  */
-BUFFER_FNS(Uptodate, uptodate)
 BUFFER_FNS(Dirty, dirty)
 TAS_BUFFER_FNS(Dirty, dirty)
 BUFFER_FNS(Lock, locked)
@@ -135,6 +134,30 @@ BUFFER_FNS(Meta, meta)
 BUFFER_FNS(Prio, prio)
 BUFFER_FNS(Defer_Completion, defer_completion)
 
+static __always_inline void set_buffer_uptodate(struct buffer_head *bh)
+{
+	/*
+	 * make it consistent with folio_mark_uptodate
+	 * pairs with smp_load_acquire in buffer_uptodate
+	 */
+	smp_mb__before_atomic();
+	set_bit(BH_Uptodate, &bh->b_state);
+}
+
+static __always_inline void clear_buffer_uptodate(struct buffer_head *bh)
+{
+	clear_bit(BH_Uptodate, &bh->b_state);
+}
+
+static __always_inline int buffer_uptodate(const struct buffer_head *bh)
+{
+	/*
+	 * make it consistent with folio_test_uptodate
+	 * pairs with smp_mb__before_atomic in set_buffer_uptodate
+	 */
+	return (smp_load_acquire(&bh->b_state) & (1UL << BH_Uptodate)) != 0;
+}
+
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
 
 /* If we *know* page->private refers to buffer_heads */



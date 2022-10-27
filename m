Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7579560FDCC
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiJ0Q7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbiJ0Q7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F3017D28B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C828B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE3C433D6;
        Thu, 27 Oct 2022 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889949;
        bh=7AmryfJwM4SUwd1aYm/HbQkX9ju2LO8GVt51Xm2nzPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAXc8Vyp1WTVWTzesRcHpmx0Vnt0bPuRew9Oc9wKf9DOTLztdU16KRBTZspoEp6uc
         QB1L1JtDy4MGvqOFj3Rd5JzB6vfquFprApDCttVuufY+7kKvgQ4oANAOSkk0jaVR5S
         Am6O2ni/Ux6XNo3tJdPz5etArIy/JUN46zkfvji4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.0 29/94] dm bufio: use the acquire memory barrier when testing for B_READING
Date:   Thu, 27 Oct 2022 18:54:31 +0200
Message-Id: <20221027165058.254553240@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 141b3523e9be6f15577acf4bbc3bc1f82d81d6d1 upstream.

The function test_bit doesn't provide any memory barrier. It may be
possible that the read requests that follow test_bit(B_READING, &b->state)
are reordered before the test, reading invalid data that existed before
B_READING was cleared.

Fix this bug by changing test_bit to test_bit_acquire. This is
particularly important on arches with weak(er) memory ordering
(e.g. arm64).

Depends-On: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
Depends-On: d6ffe6067a54 ("provide arch_test_bit_acquire for architectures that define test_bit")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -795,7 +795,8 @@ static void __make_buffer_clean(struct d
 {
 	BUG_ON(b->hold_count);
 
-	if (!b->state)	/* fast case */
+	/* smp_load_acquire() pairs with read_endio()'s smp_mb__before_atomic() */
+	if (!smp_load_acquire(&b->state))	/* fast case */
 		return;
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
@@ -816,7 +817,7 @@ static struct dm_buffer *__get_unclaimed
 		BUG_ON(test_bit(B_DIRTY, &b->state));
 
 		if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
-		    unlikely(test_bit(B_READING, &b->state)))
+		    unlikely(test_bit_acquire(B_READING, &b->state)))
 			continue;
 
 		if (!b->hold_count) {
@@ -1058,7 +1059,7 @@ found_buffer:
 	 * If the user called both dm_bufio_prefetch and dm_bufio_get on
 	 * the same buffer, it would deadlock if we waited.
 	 */
-	if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
+	if (nf == NF_GET && unlikely(test_bit_acquire(B_READING, &b->state)))
 		return NULL;
 
 	b->hold_count++;
@@ -1218,7 +1219,7 @@ void dm_bufio_release(struct dm_buffer *
 		 * invalid buffer.
 		 */
 		if ((b->read_error || b->write_error) &&
-		    !test_bit(B_READING, &b->state) &&
+		    !test_bit_acquire(B_READING, &b->state) &&
 		    !test_bit(B_WRITING, &b->state) &&
 		    !test_bit(B_DIRTY, &b->state)) {
 			__unlink_buffer(b);
@@ -1479,7 +1480,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_release_move)
 
 static void forget_buffer_locked(struct dm_buffer *b)
 {
-	if (likely(!b->hold_count) && likely(!b->state)) {
+	if (likely(!b->hold_count) && likely(!smp_load_acquire(&b->state))) {
 		__unlink_buffer(b);
 		__free_buffer_wake(b);
 	}
@@ -1639,7 +1640,7 @@ static bool __try_evict_buffer(struct dm
 {
 	if (!(gfp & __GFP_FS) ||
 	    (static_branch_unlikely(&no_sleep_enabled) && b->c->no_sleep)) {
-		if (test_bit(B_READING, &b->state) ||
+		if (test_bit_acquire(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
 			return false;



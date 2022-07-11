Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F383256FA67
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiGKJRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiGKJQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:16:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00BC419A5;
        Mon, 11 Jul 2022 02:11:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A9DB80E7D;
        Mon, 11 Jul 2022 09:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC60C34115;
        Mon, 11 Jul 2022 09:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530663;
        bh=pnH5lEehIUM44wvMDE6bRQXu7DvPpP9hGwDhZSSbevE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juunUKx2n5OJvqAf1p5OKk8yukskIn44ogTOoRfHZcedjGjWX6JhhXsEJQZ8Vh082
         I+8jJ+qtjDKlsawwJJ/e8LWwMe3fU/hPui9Rg45jkW9T97hvsHlk2ldh41KMfM6TCI
         KefGzScCEX6CiaBMM29fmY2dBayBzFppf8JiDe9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Iellin <ieitayie@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 34/38] ida: dont use BUG_ON() for debugging
Date:   Mon, 11 Jul 2022 11:07:16 +0200
Message-Id: <20220711090539.731118592@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fc82bbf4dede758007763867d0282353c06d1121 upstream.

This is another old BUG_ON() that just shouldn't exist (see also commit
a382f8fee42c: "signal handling: don't use BUG_ON() for debugging").

In fact, as Matthew Wilcox points out, this condition shouldn't really
even result in a warning, since a negative id allocation result is just
a normal allocation failure:

  "I wonder if we should even warn here -- sure, the caller is trying to
   free something that wasn't allocated, but we don't warn for
   kfree(NULL)"

and goes on to point out how that current error check is only causing
people to unnecessarily do their own index range checking before freeing
it.

This was noted by Itay Iellin, because the bluetooth HCI socket cookie
code does *not* do that range checking, and ends up just freeing the
error case too, triggering the BUG_ON().

The HCI code requires CAP_NET_RAW, and seems to just result in an ugly
splat, but there really is no reason to BUG_ON() here, and we have
generally striven for allocation models where it's always ok to just do

    free(alloc());

even if the allocation were to fail for some random reason (usually
obviously that "random" reason being some resource limit).

Fixes: 88eca0207cf1 ("ida: simplified functions for id allocation")
Reported-by: Itay Iellin <ieitayie@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/idr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -489,7 +489,8 @@ void ida_free(struct ida *ida, unsigned
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
 
 	xas_lock_irqsave(&xas, flags);
 	bitmap = xas_load(&xas);



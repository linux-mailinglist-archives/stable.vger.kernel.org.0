Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C10056FAEE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiGKJXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiGKJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5DEF5BD;
        Mon, 11 Jul 2022 02:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C9ACB80D2C;
        Mon, 11 Jul 2022 09:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F32C34115;
        Mon, 11 Jul 2022 09:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530823;
        bh=T7xOkgvjtE3PbkwxKocejNJRefdrZpo1wFeudSfDjeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNkXKI6uakFcZikxiliwddPPR9ZqkUYezsixZf+kIPaKiHLEuYiACy3uzTvQnZpSj
         kAtwyvdU9AZfEl38Zka8MVRjZUlXz190HwjMuILt1FqDQ1AoJMWAeWUrf/481MHELi
         OMlISDg1a4xnn7QNPkqNRVaVUs7LnGP7pMJmCeME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Iellin <ieitayie@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 51/55] ida: dont use BUG_ON() for debugging
Date:   Mon, 11 Jul 2022 11:07:39 +0200
Message-Id: <20220711090543.258212313@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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
@@ -491,7 +491,8 @@ void ida_free(struct ida *ida, unsigned
 	struct ida_bitmap *bitmap;
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
 
 	xas_lock_irqsave(&xas, flags);
 	bitmap = xas_load(&xas);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D743456F9C9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiGKJI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiGKJIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8F6255A0;
        Mon, 11 Jul 2022 02:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3D4C61183;
        Mon, 11 Jul 2022 09:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DD0C34115;
        Mon, 11 Jul 2022 09:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530465;
        bh=lPdGCGY4nCPJiAo2k5l1xKVFPxrsnk/2+JWwawIClYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itdkMG6JjUujmTh/CDihpCuzpBdkUTy+uA6c0T6DFTB1BPStItwjfE5M+fFf2byZE
         mIW6Y0xWDky4/ulsFTFqtqmLECbCeOYpb5qumGuThJAktZIQ+8s7imejawvgbdBkHn
         5tpbvb7cMc4kF0lUukb0HGfRof9C1w2RDUJYolj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Itay Iellin <ieitayie@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 14/17] ida: dont use BUG_ON() for debugging
Date:   Mon, 11 Jul 2022 11:06:39 +0200
Message-Id: <20220711090536.687509539@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
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
 lib/idr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -498,7 +498,9 @@ void ida_simple_remove(struct ida *ida,
 {
 	unsigned long flags;
 
-	BUG_ON((int)id < 0);
+	if ((int)id < 0)
+		return;
+
 	spin_lock_irqsave(&simple_ida_lock, flags);
 	ida_remove(ida, id);
 	spin_unlock_irqrestore(&simple_ida_lock, flags);



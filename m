Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA65B5F9909
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiJJHFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbiJJHE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3816657218;
        Mon, 10 Oct 2022 00:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0076660E33;
        Mon, 10 Oct 2022 07:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171EFC433C1;
        Mon, 10 Oct 2022 07:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385469;
        bh=UtIDBXhdAQyO1vH3evjFRrIJ49GBbhsUJXe/G1NSqZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaIGtRmB5qMBz/0Y3NP+ApzKvE3aXrqamXtgkbaowLtwB1gRCVVfq0y23Jk9gHuzN
         3rD6ctAs040kQTQ5QbBN5sl8/q3J9SibYigwRmuhc4j5Je0tdOVCX/tMDEbcKMUSZK
         cOJkWeI75/jUspU2k1z57GMK8eM0ekQrCX9RlGd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@kernel.org
Subject: [PATCH 6.0 03/17] [brown paperbag] fix coredump breakage
Date:   Mon, 10 Oct 2022 09:04:26 +0200
Message-Id: <20221010070330.284105863@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 4f526fef91b24197d489ff86789744c67f475bb4 upstream.

Let me count the ways in which I'd screwed up:

* when emitting a page, handling of gaps in coredump should happen
before fetching the current file position.
* fix for a problem that occurs on rather uncommon setups (and hadn't
been observed in the wild) had been sent very late in the cycle.
* ... with badly insufficient testing, introducing an easily
reproducible breakage.  Without giving it time to soak in -next.

Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: "J. R. Okajima" <hooanon05g@gmail.com>
Tested-by: "J. R. Okajima" <hooanon05g@gmail.com>
Fixes: 06bbaa6dc53c "[coredump] don't use __kernel_write() on kmap_local_page()"
Cc: stable@kernel.org	# v6.0-only
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -841,7 +841,7 @@ static int dump_emit_page(struct coredum
 	};
 	struct iov_iter iter;
 	struct file *file = cprm->file;
-	loff_t pos = file->f_pos;
+	loff_t pos;
 	ssize_t n;
 
 	if (cprm->to_skip) {
@@ -853,6 +853,7 @@ static int dump_emit_page(struct coredum
 		return 0;
 	if (dump_interrupted())
 		return 0;
+	pos = file->f_pos;
 	iov_iter_bvec(&iter, WRITE, &bvec, 1, PAGE_SIZE);
 	n = __kernel_write_iter(cprm->file, &iter, &pos);
 	if (n != PAGE_SIZE)



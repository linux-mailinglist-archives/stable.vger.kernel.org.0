Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA9E4D82A1
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiCNMGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240585AbiCNMFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF3496A1;
        Mon, 14 Mar 2022 05:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42032B80D24;
        Mon, 14 Mar 2022 12:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E8BC340E9;
        Mon, 14 Mar 2022 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259360;
        bh=EpphPjkJYLQvxtjYHWazgFohtokZXh676sRXQzOPIuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBBkKVAx3az7UwYqkrxN6kpEuZQp70+4r3torI8HhvBrjFUB39Fr2XOpC/oi1hoLI
         Nt/9teBv5kBrfnmq6es5PakB+3pgDncAB9ytWaGp++5FAC8GPmluBaqqF6FI0cPtVM
         2R4UkdwZowcngs2UdaQkCdEDIIRPsQQDaj4OEgPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 61/71] watch_queue: Fix to always request a pow-of-2 pipe ring size
Date:   Mon, 14 Mar 2022 12:53:54 +0100
Message-Id: <20220314112739.638370324@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 96a4d8912b28451cd62825fd7caa0e66e091d938 upstream.

The pipe ring size must always be a power of 2 as the head and tail
pointers are masked off by AND'ing with the size of the ring - 1.
watch_queue_set_size(), however, lets you specify any number of notes
between 1 and 511.  This number is passed through to pipe_resize_ring()
without checking/forcing its alignment.

Fix this by rounding the number of slots required up to the nearest
power of two.  The request is meant to guarantee that at least that many
notifications can be generated before the queue is full, so rounding
down isn't an option, but, alternatively, it may be better to give an
error if we aren't allowed to allocate that much ring space.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -244,7 +244,7 @@ long watch_queue_set_size(struct pipe_in
 		goto error;
 	}
 
-	ret = pipe_resize_ring(pipe, nr_notes);
+	ret = pipe_resize_ring(pipe, roundup_pow_of_two(nr_notes));
 	if (ret < 0)
 		goto error;
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24AD4D82AA
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240420AbiCNMGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240572AbiCNMFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7405A49254;
        Mon, 14 Mar 2022 05:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 242F9B80CDE;
        Mon, 14 Mar 2022 12:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7E1C340E9;
        Mon, 14 Mar 2022 12:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259355;
        bh=AUqtvabMwOT8H1tChuw/4DbeorIaoD6A+b5KC2+sjwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rKL/TphBMrgtrdbfZaBHDED+NO+RiPW9Lsunxis4MtBi3UowW0UodK+HdPP6MWmtn
         hQjfPJKC0xCUHG9hkqpzNjZ7XlKZRelh0AF+mRenchyKqHWaGlgs1ls0i72Vel5SQ8
         C+sgF1OcOvpvgSWECXNUyW2wHeDdo47I/HsmMFiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 60/71] watch_queue: Fix to release page in ->release()
Date:   Mon, 14 Mar 2022 12:53:53 +0100
Message-Id: <20220314112739.610601388@linuxfoundation.org>
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

commit c1853fbadcba1497f4907971e7107888e0714c81 upstream.

When a pipe ring descriptor points to a notification message, the
refcount on the backing page is incremented by the generic get function,
but the release function, which marks the bitmap, doesn't drop the page
ref.

Fix this by calling generic_pipe_buf_release() at the end of
watch_queue_pipe_buf_release().

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -54,6 +54,7 @@ static void watch_queue_pipe_buf_release
 	bit += page->index;
 
 	set_bit(bit, wqueue->notes_bitmap);
+	generic_pipe_buf_release(pipe, buf);
 }
 
 // No try_steal function => no stealing



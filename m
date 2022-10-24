Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD75960B2B3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiJXQus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiJXQtW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF0283F03;
        Mon, 24 Oct 2022 08:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDF64B811C0;
        Mon, 24 Oct 2022 12:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF57C433D6;
        Mon, 24 Oct 2022 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613203;
        bh=l6/JJYg71Tp2CdzP8UNQum0EZe0uGk6D7/A7ysK3Bd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaXnha/8/a7grlQt8T4RAetTN0RTHSGTKuicaNkWjn2amnQrv608Qc2wZ7n1aNa63
         eMSz+0U8pF/WKvFC0i82oXj1gVChDPMb5UXgwkRcMPHfpuCN3gA0iG8n+B32HZ5d3n
         //aoiExxbH9kOwgs1GDyXjY9wAGFAVGjztCb4aDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 047/255] ring-buffer: Allow splice to read previous partially read pages
Date:   Mon, 24 Oct 2022 13:29:17 +0200
Message-Id: <20221024113004.000546176@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit fa8f4a89736b654125fb254b0db753ac68a5fced upstream.

If a page is partially read, and then the splice system call is run
against the ring buffer, it will always fail to read, no matter how much
is in the ring buffer. That's because the code path for a partial read of
the page does will fail if the "full" flag is set.

The splice system call wants full pages, so if the read of the ring buffer
is not yet full, it should return zero, and the splice will block. But if
a previous read was done, where the beginning has been consumed, it should
still be given to the splice caller if the rest of the page has been
written to.

This caused the splice command to never consume data in this scenario, and
let the ring buffer just fill up and lose events.

Link: https://lkml.kernel.org/r/20220927144317.46be6b80@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 8789a9e7df6bf ("ring-buffer: read page interface")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4825,7 +4825,15 @@ int ring_buffer_read_page(struct ring_bu
 		unsigned int pos = 0;
 		unsigned int size;
 
-		if (full)
+		/*
+		 * If a full page is expected, this can still be returned
+		 * if there's been a previous partial read and the
+		 * rest of the page can be read and the commit page is off
+		 * the reader page.
+		 */
+		if (full &&
+		    (!read || (len < (commit - read)) ||
+		     cpu_buffer->reader_page == cpu_buffer->commit_page))
 			goto out_unlock;
 
 		if (len > (commit - read))



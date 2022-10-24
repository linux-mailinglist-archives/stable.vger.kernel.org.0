Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4390760A4F6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiJXMT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiJXMTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:19:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA507B1C8;
        Mon, 24 Oct 2022 04:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42B32612C5;
        Mon, 24 Oct 2022 11:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50591C433D6;
        Mon, 24 Oct 2022 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612640;
        bh=rXUczMZfXkDFr9soqB73mBsjMgHKD7tfG7kUhKLKykI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VXhOjOFcEFgewQmf/9eSXPWdQMjQE2jr9ghVhEVbX0mHRxT2+zSJIJ07G5RlKbrB
         SMVP4maNf3696VF3kTdfyFl4Fc1h57C+TkJxOyED6urn00VzZh49F84e1lCv3ovu0c
         1/KxnxZzHJsmC1HDe1dWfclVv5mPb+3OmIiStM7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 064/229] ring-buffer: Allow splice to read previous partially read pages
Date:   Mon, 24 Oct 2022 13:29:43 +0200
Message-Id: <20221024113001.154006209@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
@@ -4770,7 +4770,15 @@ int ring_buffer_read_page(struct ring_bu
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



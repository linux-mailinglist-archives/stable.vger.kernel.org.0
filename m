Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15139483236
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiACOZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56208 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiACOZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5384D61117;
        Mon,  3 Jan 2022 14:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ACCC36AEF;
        Mon,  3 Jan 2022 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219937;
        bh=6NFMk94zYp0v4csIDxeIfG4wpPjoHwGKRXR2wVaTjPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOHER7hnGONctdPqigKbRN/lTGBF3HnzsYyacZAZX0ZM0T+380pw83GUs4vUchDrY
         qjQKFAnoXNqGyfEG9JduxLjVy1OKy0grv4oxuh1z163zAAZMFd98gkc517iZzV1ljx
         54/VQ/UXm2RRKq784MAbG6GT/rfswEx6zgUIGB4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 4.19 23/27] binder: fix async_free_space accounting for empty parcels
Date:   Mon,  3 Jan 2022 15:24:03 +0100
Message-Id: <20220103142052.910309259@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Todd Kjos <tkjos@google.com>

commit cfd0d84ba28c18b531648c9d4a35ecca89ad9901 upstream.

In 4.13, commit 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
fixed a kernel structure visibility issue. As part of that patch,
sizeof(void *) was used as the buffer size for 0-length data payloads so
the driver could detect abusive clients sending 0-length asynchronous
transactions to a server by enforcing limits on async_free_size.

Unfortunately, on the "free" side, the accounting of async_free_space
did not add the sizeof(void *) back. The result was that up to 8-bytes of
async_free_space were leaked on every async transaction of 8-bytes or
less.  These small transactions are uncommon, so this accounting issue
has gone undetected for several years.

The fix is to use "buffer_size" (the allocated buffer size) instead of
"size" (the logical buffer size) when updating the async_free_space
during the free operation. These are the same except for this
corner case of asynchronous transactions with payloads < 8 bytes.

Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
Signed-off-by: Todd Kjos <tkjos@google.com>
Cc: stable@vger.kernel.org # 4.14+
Link: https://lore.kernel.org/r/20211220190150.2107077-1-tkjos@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -630,7 +630,7 @@ static void binder_free_buf_locked(struc
 	BUG_ON(buffer->data > alloc->buffer + alloc->buffer_size);
 
 	if (buffer->async_transaction) {
-		alloc->free_async_space += size + sizeof(struct binder_buffer);
+		alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
 
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_free_buf size %zd async free %zd\n",



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33064832A3
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiACO3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiACO2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B84C0698D3;
        Mon,  3 Jan 2022 06:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48282B80EF2;
        Mon,  3 Jan 2022 14:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9C5C36AF0;
        Mon,  3 Jan 2022 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220086;
        bh=iZTFXKSwQoFLul70I3cCFwLfy+l08i9jLlhkuDlt3AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUnIfKFkx0mNZ+6qqCP863wWh6yG3pn60j5NdpLrkjC1H2BVobEURICX9FPZ2AzYL
         cJWQZI9ad1NtcDBQl+Lm9y/QYyUKA2qANz5bHp5YX1B17hmZgcuIfUjNHX0rYM+Vwr
         +fIk/YHKGm/VAB4DHItMjc+hdynZrpxz8Y+tufb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 32/37] binder: fix async_free_space accounting for empty parcels
Date:   Mon,  3 Jan 2022 15:24:10 +0100
Message-Id: <20220103142052.866161692@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
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
@@ -613,7 +613,7 @@ static void binder_free_buf_locked(struc
 	BUG_ON(buffer->user_data > alloc->buffer + alloc->buffer_size);
 
 	if (buffer->async_transaction) {
-		alloc->free_async_space += size + sizeof(struct binder_buffer);
+		alloc->free_async_space += buffer_size + sizeof(struct binder_buffer);
 
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC_ASYNC,
 			     "%d: binder_free_buf size %zd async free %zd\n",



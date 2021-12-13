Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB41472A13
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238189AbhLMKaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240248AbhLMK23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFCEC01DF32;
        Mon, 13 Dec 2021 02:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3854CB80E9E;
        Mon, 13 Dec 2021 10:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0CFC34601;
        Mon, 13 Dec 2021 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389727;
        bh=7aBTmzFs0Yc5JQWF+HKfurBmN7Lszq5th7rWPvULqgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/Bm8rvdggab1beZCK8MIhXM7a1NhCXzSvt/odHvTqCudzVQ50VFS0Qubz0ioZ5Vs
         akvdqmu8GBUv9mxzwIpn2GT13uNfWrT6bwZrkhQvaI5/MR9/wYyyh4ff7k8ClTHxO0
         p5xTTq5Epl2NYIQjH5P/xU89EpdyCNzQBNq/5cOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 166/171] aio: Fix incorrect usage of eventfd_signal_allowed()
Date:   Mon, 13 Dec 2021 10:31:21 +0100
Message-Id: <20211213092950.596470498@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit 4b3749865374899e115aa8c48681709b086fe6d3 upstream.

We should defer eventfd_signal() to the workqueue when
eventfd_signal_allowed() return false rather than return
true.

Fixes: b542e383d8c0 ("eventfd: Make signal recursion protection a task bit")
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210913111928.98-1-xieyongji@bytedance.com
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1761,7 +1761,7 @@ static int aio_poll_wake(struct wait_que
 		list_del_init(&req->wait.entry);
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
-		if (iocb->ki_eventfd && eventfd_signal_allowed()) {
+		if (iocb->ki_eventfd && !eventfd_signal_allowed()) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
 			schedule_work(&req->work);



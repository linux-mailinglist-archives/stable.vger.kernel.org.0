Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BA06584B2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbiL1RAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiL1Q77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:59:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415C11EACD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D27D161562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBD9C433D2;
        Wed, 28 Dec 2022 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246520;
        bh=t4w4tTd+jxKas6MdnngrVvTCpDcYkbpW0+KPNov1NfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GApleOwVgLNUaePhz8pgUacUDqI0b2SRTjDCMbGsM2Br/bnRNV87sBvBGzeJcJiN
         qotMfHyP2VwYUrhjFYPu7cwuxZ51Kn75KlU4ZMxjZhQJAhClTjsw00jr0Ij+jODoNy
         y9nD/K6eCy44ZRd7yzWB7MM05deSqzrf9H/0Tih0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 1061/1073] io_uring/net: fix cleanup after recycle
Date:   Wed, 28 Dec 2022 15:44:09 +0100
Message-Id: <20221228144357.053975266@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6c3e8955d4bd9811a6e1761eea412a14fb51a2e6 upstream.

Don't access io_async_msghdr io_netmsg_recycle(), it may be reallocated.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e5 ("io_uring: support multishot in recvmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9e326f4ad4046ddadf15bf34bf3fa58c6372f6b5.1671461985.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -772,10 +772,10 @@ retry_multishot:
 		goto retry_multishot;
 
 	if (mshot_finished) {
-		io_netmsg_recycle(req, issue_flags);
 		/* fast path, check for non-NULL to avoid function call */
 		if (kmsg->free_iov)
 			kfree(kmsg->free_iov);
+		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 



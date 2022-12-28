Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F16658502
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiL1RFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiL1REK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE8E201B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97DCDB81889
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD1FC433EF;
        Wed, 28 Dec 2022 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246725;
        bh=RUtcLkRHHDi1hY3r4tl1MdIhjJYas7Mm/RCXa6vfhd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJq/VYuMwT/fbDnXqeSCJvISIRnqn+gbG2L74s+JOPfXOl5fCTjdGP0qREWNTT+C2
         9ibvx4l/pKDXcwcFPxBp24gxhrL6vEe/0fvGyW3oUQE8jayMDadH9vKsZXqbU+zFlL
         wfa3K9tH4KSWqE0j+OQg5kQUqBy07MOMP7MD+KG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1140/1146] io_uring/net: fix cleanup after recycle
Date:   Wed, 28 Dec 2022 15:44:39 +0100
Message-Id: <20221228144401.107054775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
@@ -806,10 +806,10 @@ retry_multishot:
 		goto retry_multishot;
 
 	if (mshot_finished) {
-		io_netmsg_recycle(req, issue_flags);
 		/* fast path, check for non-NULL to avoid function call */
 		if (kmsg->free_iov)
 			kfree(kmsg->free_iov);
+		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 



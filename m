Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D38593CB0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiHOUCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345919AbiHOUA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15217B1E3;
        Mon, 15 Aug 2022 11:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F22E8B8105D;
        Mon, 15 Aug 2022 18:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44177C433D6;
        Mon, 15 Aug 2022 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589610;
        bh=6lz2YdPTiZjJvSA/4Pbq2dAES/xNXwk3Yc/pcvU3EkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4mdesZSS+tdyfZ/qJb2wX5d0gdM2maZQkqQvAjp3ug3B5yzvOaCMG0KVccVB1vfJ
         nL+OhTWYAL4y66rUpUInfd81Qc0xdFCzTjYz0inhPmMUI4jWCIbNcJ4c4gcMjPRxjW
         XW/t4Np5SWg48mgdSpHnqPyETQZjP3FH65nTGWTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 773/779] io_uring: mem-account pbuf buckets
Date:   Mon, 15 Aug 2022 20:06:57 +0200
Message-Id: <20220815180410.444136632@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit cc18cc5e82033d406f54144ad6f8092206004684 upstream.

Potentially, someone may create as many pbuf bucket as there are indexes
in an xarray without any other restrictions bounding our memory usage,
put memory needed for the buckets under memory accounting.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d34c452e45793e978d26e2606211ec9070d329ea.1659622312.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4477,7 +4477,8 @@ static int io_provide_buffers(struct io_
 
 	ret = io_add_buffers(p, &head);
 	if (ret >= 0 && !list) {
-		ret = xa_insert(&ctx->io_buffers, p->bgid, head, GFP_KERNEL);
+		ret = xa_insert(&ctx->io_buffers, p->bgid, head,
+				GFP_KERNEL_ACCOUNT);
 		if (ret < 0)
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
 	}



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80005949C4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354121AbiHOXnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354315AbiHOXlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BE62C64D;
        Mon, 15 Aug 2022 13:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC76FB80EA9;
        Mon, 15 Aug 2022 20:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC26C433D6;
        Mon, 15 Aug 2022 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594334;
        bh=WkeaMXg8g2mDWR9wbrsSqC/qSPKJQjDfLTRD4TGn7zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9rYiX/vwMDh9S3NQigifed4vlelYja8A/rWjOzlezFGhIA+P5XHDg234CbNJgJVJ
         UxYbu/W2VQF6mKjDFpEDicSTJH2gKXWtjJIq1OUznFcvSzcUKTcw8AaDrvP3LtivmT
         0Ne7HDXh94BuHAzH+QSpXMh/zUdEKcyvjieZ6lmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 1094/1095] io_uring: mem-account pbuf buckets
Date:   Mon, 15 Aug 2022 20:08:13 +0200
Message-Id: <20220815180514.265719320@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4927,7 +4927,7 @@ static int io_provide_buffers(struct io_
 
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
-		bl = kmalloc(sizeof(*bl), GFP_KERNEL);
+		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
 		if (!bl) {
 			ret = -ENOMEM;
 			goto err;



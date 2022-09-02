Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209015AB12E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbiIBNG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiIBNGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:06:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7EBEA8AD;
        Fri,  2 Sep 2022 05:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 085A862194;
        Fri,  2 Sep 2022 12:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B37C433D6;
        Fri,  2 Sep 2022 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121892;
        bh=exs1M14G2hFHIOYMQ8AYApY+iIFCvLSFnU0OjU75pHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xD5hvNG0pn5RpVX/G8wsHM8LOHvXZ5dMcEWmxQUiK4zHfjK2R9inNbdA3DrQYaRDh
         +NEK2E66o24zNDCXCSqgG5eGYzWkXtlKh0TeTlER/TObxU608iOQ2TuTjt5BZlnyZj
         bJ71LFazFacGTIMFnGJoGVueb8qrQ1om66YrUnbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.15 20/73] io_uring: bump poll refs to full 31-bits
Date:   Fri,  2 Sep 2022 14:18:44 +0200
Message-Id: <20220902121405.123856088@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ upstream commmit e2c0cb7c0cc72939b61a7efee376206725796625 ]

The previous commit:

1bc84c40088 ("io_uring: remove poll entry from list when canceling all")

removed a potential overflow condition for the poll references. They
are currently limited to 20-bits, even if we have 31-bits available. The
upper bit is used to mark for cancelation.

Bump the poll ref space to 31-bits, making that kind of situation much
harder to trigger in general. We'll separately add overflow checking
and handling.

Fixes: aa43477b0402 ("io_uring: poll rework")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5314,7 +5314,7 @@ struct io_poll_table {
 };
 
 #define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_REF_MASK	((1u << 20)-1)
+#define IO_POLL_REF_MASK	GENMASK(30, 0)
 
 /*
  * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can



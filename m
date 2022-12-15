Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3F64E052
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiLOSLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiLOSLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:11:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082632ED5B
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB2A2B81C34
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF4DC433D2;
        Thu, 15 Dec 2022 18:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127910;
        bh=feab34fh60OkZ5o0LqhME3It700OtN3FvjGK4gz1a+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3IN6eANEpHo/HTGMt6XInclGbJ4Tvjhem2ZlRuyx2scu9irAw53kUwymBeAJSU6v
         tay+xAQAZq2QumiHc1DJJm42ZvAD16lrGxrzJUjg+0ErCvtQz4D31fG+AWJShBAiTf
         fDljyaaYvMPjQU7wsM1CtagFr18T8Ydy5IdRsjJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bing-Jhong Billy Jheng <billy@starlabs.sg>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 06/15] io_uring: add missing item types for splice request
Date:   Thu, 15 Dec 2022 19:10:33 +0100
Message-Id: <20221215172907.290429481@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
References: <20221215172906.638553794@linuxfoundation.org>
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

From: Bing-Jhong Billy Jheng <billy@starlabs.sg>

Splice is like read/write and should grab current->nsproxy, denoted by
IO_WQ_WORK_FILES as it refers to current->files as well

Signed-off-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -936,7 +936,7 @@ static const struct io_op_def io_op_defs
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FILES,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},



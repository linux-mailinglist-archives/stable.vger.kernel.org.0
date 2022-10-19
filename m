Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E8603BBC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiJSIjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiJSIii (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:38:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6373981123;
        Wed, 19 Oct 2022 01:38:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B4FAB822BE;
        Wed, 19 Oct 2022 08:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C4C433C1;
        Wed, 19 Oct 2022 08:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168672;
        bh=6AAYlz6WMbyiz2zlzUmiFzfmzMYzCpqeoaRixFgbwJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE41ptUGKeM6c75YC0s9BvP+MKPFwWltgJuEAyu+SfzQ45F3X0pW9IZRoikK4pJuj
         iJ/EnMxbd58dUUudyEJKbmfs1o80zy1ppkPXgBBfSzx1ZCxSegqmNGr0yXKglkQy2T
         ldB/lMHuk0lQA3Tv+amJBmi0JKuHLkLb/oELkXgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 017/862] io_uring: limit registration w/ SINGLE_ISSUER
Date:   Wed, 19 Oct 2022 10:21:44 +0200
Message-Id: <20221019083250.770950056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit d7cce96c449e35bbfd41e830b341b95973891eed upstream.

IORING_SETUP_SINGLE_ISSUER restricts what tasks can submit requests.
Extend it to registration as well, so non-owning task can't do
registrations. It's not necessary at the moment but might be useful in
the future.

Cc: <stable@vger.kernel.org> # 6.0
Fixes: 97bbdc06a444 ("io_uring: add IORING_SETUP_SINGLE_ISSUER")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f52a6a9c8a8990d4a831f73c0571e7406aac2bba.1664237592.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3710,6 +3710,9 @@ static int __io_uring_register(struct io
 	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
 		return -ENXIO;
 
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;
+
 	if (ctx->restricted) {
 		if (opcode >= IORING_REGISTER_LAST)
 			return -EINVAL;



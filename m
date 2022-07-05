Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129F8566D1D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiGEMVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbiGEMRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEDE1C904;
        Tue,  5 Jul 2022 05:12:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80CCF619A6;
        Tue,  5 Jul 2022 12:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91002C341C8;
        Tue,  5 Jul 2022 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023138;
        bh=Zvrqgx3TWHUPdHczpbHvYScItmS0flh1Wg5GahmqYxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xN66xuqmC+14N6+OuvUuFcNUpaKoMKWIGu3mNnVBj7OUeqk0ZutEQv+vAy6pk41qW
         5RGH9hRipH3kkcYG7UAPhZ7N89tg6FqLmCyrgGC7+Jad5R+vTwS2+736ecnv81I4Mk
         9tcLIMcPdYBwGL0/wiYAF/KhPyU+y7i7RvSizG+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 52/98] io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio
Date:   Tue,  5 Jul 2022 13:58:10 +0200
Message-Id: <20220705115619.061142527@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 73911426aaaadbae54fa72359b33a7b6a56947db upstream.

All other opcodes correctly check if this is set and -EINVAL if it is
and they don't support that field, for some reason the these were
forgotten.

This was unified a bit differently in the upstream tree, but had the
same effect as making sure we error on this field. Rather than have
a painful backport of the upstream commit, just fixup the mentioned
opcodes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4788,6 +4788,8 @@ static int io_sendmsg_prep(struct io_kio
 		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5011,6 +5013,8 @@ static int io_recvmsg_prep(struct io_kio
 		return -EINVAL;
 	if (unlikely(sqe->addr2 || sqe->file_index))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);



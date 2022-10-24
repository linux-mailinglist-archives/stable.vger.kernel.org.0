Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B045E60A1C4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJXLdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJXLci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F866173F;
        Mon, 24 Oct 2022 04:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2FE6125A;
        Mon, 24 Oct 2022 11:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1EFC433C1;
        Mon, 24 Oct 2022 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611139;
        bh=ls/FY9lIc8Kn+4qnUhrnD5jdUO7ASdakq191rkjNnn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xu4Yt9bh+wGUtgjjFC+/H9HxJuAVvvixqq7HBKJW5TjjMzRVjgyOPRNQ/XHmFcVgh
         B1Ri1K3OWKnZTD4SsFSnlBeSYUGqymDsa+m+g597aXe1k69XlJVt/XzmdC0E3DfYiY
         JzlfsJ9OjD7KSurg7cP/piqqL+2LyYUDABkYAyro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 05/20] io_uring/net: fail zc send when unsupported by socket
Date:   Mon, 24 Oct 2022 13:31:07 +0200
Message-Id: <20221024112934.634360980@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit edf81438799ccead7122948446d7e44b083e788d upstream.

If a protocol doesn't support zerocopy it will silently fall back to
copying. This type of behaviour has always been a source of troubles
so it's better to fail such requests instead.

Cc: <stable@vger.kernel.org> # 6.0
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2db3c7f16bb6efab4b04569cd16e6242b40c5cb3.1666346426.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1001,6 +1001,8 @@ int io_send_zc(struct io_kiocb *req, uns
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		return -EOPNOTSUPP;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;



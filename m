Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F326584FF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiL1RFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiL1REE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580DB21812
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E3C61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1502C433EF;
        Wed, 28 Dec 2022 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246717;
        bh=VD6GBjq3zdp8wQ6etnsD14tWeHJVLxbgVHF2WdcfFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbtA0mr4xVqushyVOB+OH0wEq1wEXQdP+H2dfqjdv5j2Vq0Uc2x8ZCHQCyqz7NH5w
         Usm44iFG3pUJ3DHVKs33mgBels9fAzX+M5nH6qgQDWcrvzstB9KTUAw2+TH7Q9XD2K
         2nvsgFOOilGUZQZeqaLQFWTmMlMT/oSV+b6QmmBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1138/1146] io_uring: improve io_double_lock_ctx fail handling
Date:   Wed, 28 Dec 2022 15:44:37 +0100
Message-Id: <20221228144401.054062251@linuxfoundation.org>
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

commit 4c979eaefa4356d385b7c7d2877dc04d7fe88969 upstream.

msg_ring will fail the request if it can't lock rings, instead punt it
to io-wq as was originally intended.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4697f05afcc37df5c8f89e2fe6d9c7c19f0241f9.1670384893.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -164,6 +164,8 @@ int io_msg_ring(struct io_kiocb *req, un
 	}
 
 done:
+	if (ret == -EAGAIN)
+		return -EAGAIN;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);



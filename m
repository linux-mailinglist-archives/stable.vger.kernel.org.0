Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3709505073
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbiDRMZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiDRMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F58F1D0DE;
        Mon, 18 Apr 2022 05:19:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C4EC60F0A;
        Mon, 18 Apr 2022 12:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AF2C385A1;
        Mon, 18 Apr 2022 12:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284369;
        bh=N8CxiVuHzPHJ0BNRM4lnhe/0TLjk3RtN46UbVkEKNtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElVlyqyCaO/tbKCSTsVV4fc0vkIFAneKLdNQPkKvMjfUV44DWIj5N2DG6Oiscewf+
         +FpfB8avy4kY5epN/dBkvirjrGKsklE4VbclnCIy5+g84Qmh0zgyViq0OAVY4Ep/RA
         Rhf8keD6NV2ESggOAPXDi+mTzmt7YmoOY+LN12Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 084/219] io_uring: flag the fact that linked file assignment is sane
Date:   Mon, 18 Apr 2022 14:10:53 +0200
Message-Id: <20220418121208.719185493@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c4212f3eb89fd5654f0a6ed2ee1d13fcb86cb664 ]

Give applications a way to tell if the kernel supports sane linked files,
as in files being assigned at the right time to be able to reliably
do <open file direct into slot X><read file from slot X> while using
IOSQE_IO_LINK to order them.

Not really a bug fix, but flag it as such so that it gets pulled in with
backports of the deferred file assignment.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c                 | 3 ++-
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a9630dc5361..d13f142793f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10566,7 +10566,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP;
+			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
+			IORING_FEAT_LINKED_FILE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..1e45368ad33f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -293,6 +293,7 @@ struct io_uring_params {
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
+#define IORING_FEAT_LINKED_FILE		(1U << 12)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.35.1




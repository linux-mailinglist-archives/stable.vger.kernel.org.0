Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE7B4F42A0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383426AbiDEMZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241325AbiDEK4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A6BAC905;
        Tue,  5 Apr 2022 03:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06C1B81C8A;
        Tue,  5 Apr 2022 10:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340E8C385A0;
        Tue,  5 Apr 2022 10:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154518;
        bh=jvR56L6/fJAphKqjnHqF7RG12HbFeNFPnqr3S53vyzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqEL205MOy54ce9GKn9bx+/2AAm5f0uFC6V/hE6UgjeA2wvZ2PS4yB+cC8FQN7Z3e
         HM+MSsQiKwFQdqjc8ZovaXsDAsGWMeQbXb0PlGIz7nWk/Qyq65uVqi3qgtlt6RDUiu
         2M1gCXwuZeP/ocIxlEkeTIfmT5Qah5Oh0nbDBG60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 567/599] io_uring: fix memory leak of uid in files registration
Date:   Tue,  5 Apr 2022 09:34:21 +0200
Message-Id: <20220405070315.714802826@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

commit c86d18f4aa93e0e66cda0e55827cd03eea6bc5f8 upstream.

When there are no files for __io_sqe_files_scm() to process in the
range, it'll free everything and return. However, it forgets to put uid.

Fixes: 08a451739a9b5 ("io_uring: allow sparse fixed file sets")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/accee442376f33ce8aaebb099d04967533efde92.1648226048.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7350,6 +7350,7 @@ static int __io_sqe_files_scm(struct io_
 			fput(fpl->fp[i]);
 	} else {
 		kfree_skb(skb);
+		free_uid(fpl->user);
 		kfree(fpl);
 	}
 



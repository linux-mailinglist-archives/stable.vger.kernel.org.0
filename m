Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B545F60B319
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJXQ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbiJXQst (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:48:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7497A580B2;
        Mon, 24 Oct 2022 08:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D609FB810D8;
        Mon, 24 Oct 2022 12:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E61C433D6;
        Mon, 24 Oct 2022 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616135;
        bh=d2nipfW713jklC7V+Tq2HFCLGYHHTS2O1CDr8QguAGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeLyZYMJk8kD4sMSLWfVe7AxAGE67wxb7ZgaAjBC2o46EHDzz+rQLQuXgfqQHvBZ4
         umji0+aU4+by60/Lc78NdvpHBm/0567ndz/No8P2mZTifzyii5maZHVra5cobtcI6u
         cZ4q1YnAUIsGMh97psYlPK2hp4WrAy5+maD/zZxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 514/530] io_uring/rw: fix errored retry return values
Date:   Mon, 24 Oct 2022 13:34:18 +0200
Message-Id: <20221024113108.274007846@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

[ upstream commit 62bb0647b14646fa6c9aa25ecdf67ad18f13523c ]

Kernel test robot reports that we test negativity of an unsigned in
io_fixup_rw_res() after a recent change, which masks error codes and
messes up the return value in case I/O is re-retried and failed with
an error.

Fixes: 4d9cb92ca41dd ("io_uring/rw: fix short rw error handling")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9754a0970af1861e7865f9014f735c70dc60bf79.1663071587.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(stru
 	return false;
 }
 
-static inline unsigned io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
 {
 	struct io_async_rw *io = req->async_data;
 



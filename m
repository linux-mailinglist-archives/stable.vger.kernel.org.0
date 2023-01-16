Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91DE066C616
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjAPQOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjAPQOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:14:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6992BEE8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8FEDB8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A3C433EF;
        Mon, 16 Jan 2023 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885293;
        bh=OPAaUWss3kggRsLZ9Cx/clbiMcyzfs3WLyn5KB1BSUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSefxa6e1rdUC87P2mTd/K4AN4yj4i5vvlZti84ENc4bEc9kQrRfI/eorS1RQidRG
         Fcai3OOEH/yeG9LoGBk2A2fX921U6pWuZ34wI7300ZXTiprQ1MpUFijMXPPP3zpdtN
         IbJyPbWkUs20uz7kuDVEJl7OzatAYc1+Ks1l2AvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=EC=A7=84=ED=98=B8?= <wnwlsgh98@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 62/64] io_uring/io-wq: free worker if task_work creation is canceled
Date:   Mon, 16 Jan 2023 16:52:09 +0100
Message-Id: <20230116154745.751671022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit af82425c6a2d2f347c79b63ce74fca6dc6be157f upstream.

If we cancel the task_work, the worker will never come into existance.
As this is the last reference to it, ensure that we get it freed
appropriately.

Cc: stable@vger.kernel.org
Reported-by: 진호 <wnwlsgh98@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1217,6 +1217,7 @@ static void io_wq_cancel_tw_create(struc
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
+		kfree(worker);
 	}
 }
 



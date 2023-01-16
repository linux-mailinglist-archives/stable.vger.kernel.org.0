Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E2F66C596
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjAPQHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjAPQHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:07:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE612413B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68A47B81082
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF17DC433F0;
        Mon, 16 Jan 2023 16:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885121;
        bh=OPAaUWss3kggRsLZ9Cx/clbiMcyzfs3WLyn5KB1BSUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gu86muIONjRq8OBJe3FBRAkHT8jGTZZbcqoPOIppOW5tfHJd/hM96JfWG/tVZiXDy
         m5nmTGE+866DA5TTrXYba6VJ+ZFBzKpuKHTlO/qEHQmYlVi+6Pr5EnOXCvXfPI5a3H
         UG1xtxeZWrtH3soR3NFVuvhHWDS1DPSdMufJr3N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=EC=A7=84=ED=98=B8?= <wnwlsgh98@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 82/86] io_uring/io-wq: free worker if task_work creation is canceled
Date:   Mon, 16 Jan 2023 16:51:56 +0100
Message-Id: <20230116154750.448709266@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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
 



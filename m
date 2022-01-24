Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736DD499F83
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381733AbiAXW6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588119AbiAXWbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A2C02B868;
        Mon, 24 Jan 2022 12:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2A560C60;
        Mon, 24 Jan 2022 20:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933CBC340E5;
        Mon, 24 Jan 2022 20:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057764;
        bh=FRJ1sEdX/ouz9H8PhmcqYykcpScjvm5uCXoa1Ym69nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgt1qOug0IMXoIPiEiAxXaHh0zwWTAaHNSkG6EIvKKCpvyfmHXCVXGoodIj1W+XMY
         2HghDfWRs0rtWg06MNUvHQM3nixzUNZEvgZ1vHOdmZncTZufizipUwYIiSZxpqzB0q
         jkRGrvi+oPb6Dob0Z451JR01eZ1CivzpEzRYThHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 0071/1039] io_uring: fix no lock protection for ctx->cq_extra
Date:   Mon, 24 Jan 2022 19:31:00 +0100
Message-Id: <20220124184127.559922995@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Xu <haoxu@linux.alibaba.com>

commit e302f1046f4c209291b07ff7bc4d15ca26891f16 upstream.

ctx->cq_extra should be protected by completion lock so that the
req_need_defer() does the right check.

Cc: stable@vger.kernel.org
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20211125092103.224502-2-haoxu@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6544,12 +6544,15 @@ static __cold void io_drain_req(struct i
 	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
+	spin_lock(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
+		spin_unlock(&ctx->completion_lock);
 queue:
 		ctx->drain_active = false;
 		io_req_task_queue(req);
 		return;
 	}
+	spin_unlock(&ctx->completion_lock);
 
 	ret = io_req_prep_async(req);
 	if (ret) {



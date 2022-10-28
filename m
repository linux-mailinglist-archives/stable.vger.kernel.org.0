Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C82611061
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJ1ME5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiJ1MEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C769E2A279
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4177762807
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AFBC433C1;
        Fri, 28 Oct 2022 12:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958687;
        bh=rTHBVnBpcW68aeZKtLNTfyrFKp+Sym6n6PggK+rcHmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtFLfEpqb/p3MmNESk9GJIFtT+P1Sz1RGxUEjoZwMRXOErCHYW8V2FP+0tlqix7G7
         XoHfc7M91IEiJcmtDCy2e+5Iotvha3I85x8BVU36tAeetCoH+k2EHt+nhtqwVXVKRt
         zZjZ76x++3atfO7IOsFML/DuGCZP2SjvPX+IN7N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lei Chen <lennychen@tencent.com>,
        Jens Axboe <axboe@kernel.dk>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 5.10 15/73] block: wbt: Remove unnecessary invoking of wbt_update_limits in wbt_init
Date:   Fri, 28 Oct 2022 14:03:12 +0200
Message-Id: <20221028120233.030752498@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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

From: Lei Chen <lennychen@tencent.com>

commit 5a20d073ec54a72d9a732fa44bfe14954eb6332f upstream.

It's unnecessary to call wbt_update_limits explicitly within wbt_init,
because it will be called in the following function wbt_queue_depth_changed.

Signed-off-by: Lei Chen <lennychen@tencent.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -840,7 +840,6 @@ int wbt_init(struct request_queue *q)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = 1;
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
-	wbt_update_limits(rwb);
 
 	/*
 	 * Assign rwb and add the stats callback.



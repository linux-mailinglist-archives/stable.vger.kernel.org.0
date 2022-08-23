Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6F59D67B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348209AbiHWJJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347950AbiHWJIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812E585FDA;
        Tue, 23 Aug 2022 01:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89B6A6148E;
        Tue, 23 Aug 2022 08:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CB4C433B5;
        Tue, 23 Aug 2022 08:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243354;
        bh=9a8VWOB3kHtWZih/DNfyhw7RMpOevoUeaUMm2JCDfYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWgw/VAWW4OWC8KkB/IvltvKg6+hF7kwc1tLcfRBokMUGmzss3tZ1JjEl18Yz45NL
         /9Ng+IN6+I4R76adl4y0QUCBetj4SYHP6qXEWKlwjM1CS9Ufn8gqai7ay9QRd40IM4
         UXA2f4NP6DMwB44/e1/WQCxDfgWTTMwFzMiCVpxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 233/365] blk-mq: run queue no matter whether the request is the last request
Date:   Tue, 23 Aug 2022 10:02:14 +0200
Message-Id: <20220823080127.972131997@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yufen Yu <yuyufen@huawei.com>

commit d3b38596875dbc709b4e721a5873f4663d8a9ea2 upstream.

We do test on a virtio scsi device (/dev/sda) and the default mq
scheduler is 'none'. We found a IO hung as following:

blk_finish_plug
  blk_mq_plug_issue_direct
      scsi_mq_get_budget
      //get budget_token fail and sdev->restarts=1

			     	 scsi_end_request
				   scsi_run_queue_async
                                   //sdev->restart=0 and run queue

     blk_mq_request_bypass_insert
        //add request to hctx->dispatch list

  //continue to dispath plug list
  blk_mq_dispatch_plug_list
      blk_mq_try_issue_list_directly
        //success issue all requests from plug list

After .get_budget fail, scsi_mq_get_budget will increase 'restarts'.
Normally, it will run hw queue when io complete and set 'restarts'
as 0. But if we run queue before adding request to the dispatch list
and blk_mq_dispatch_plug_list also success issue all requests, then
on one will run queue, and the request will be stall in the dispatch
list and cannot complete forever.

It is wrong to use last request of plug list to decide if run queue is
needed since all the remained requests in plug list may be from other
hctxs. To fix the bug, pass run_queue as true always to
blk_mq_request_bypass_insert().

Fix-suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Fixes: dc5fc361d891 ("block: attempt direct issue of plug list")
Link: https://lore.kernel.org/r/20220803023355.3687360-1-yuyufen@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2568,7 +2568,7 @@ static void blk_mq_plug_issue_direct(str
 			break;
 		case BLK_STS_RESOURCE:
 		case BLK_STS_DEV_RESOURCE:
-			blk_mq_request_bypass_insert(rq, false, last);
+			blk_mq_request_bypass_insert(rq, false, true);
 			blk_mq_commit_rqs(hctx, &queued, from_schedule);
 			return;
 		default:



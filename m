Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027AA58DDE2
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344884AbiHISHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbiHISGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:06:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098626112;
        Tue,  9 Aug 2022 11:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5D48B816A0;
        Tue,  9 Aug 2022 18:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BF5C43470;
        Tue,  9 Aug 2022 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068175;
        bh=LVK7Kh2hdJ0k8iNs9K6078HDnZHYovn17rMstcfj3g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8g9RPkDXycdXE/gfOj3bfWIPae1cnQfmD8CFFPw3hlVd/p912O9PoOsg/IVPdubX
         ppAukz80vz3OVXyTc01nZkwCJsT+PGJnKjnZfz2y/7Fr4GJC92CyPVporaOygWDouA
         G0yku1xq5Vzpfe8zGAFDnRIajag5Dri/tdY76wXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 4.19 27/32] scsi: core: Fix race between handling STS_RESOURCE and completion
Date:   Tue,  9 Aug 2022 20:00:18 +0200
Message-Id: <20220809175513.938731002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

commit 673235f915318ced5d7ec4b2bfd8cb909e6a4a55 upstream.

When queuing I/O request to LLD, STS_RESOURCE may be returned because:

 - Host is in recovery or blocked

 - Target queue throttling or target is blocked

 - LLD rejection

In these scenarios BLK_STS_DEV_RESOURCE is returned to the block layer to
avoid an unnecessary re-run of the queue. However, all of the requests
queued to this SCSI device may complete immediately after reading
'sdev->device_busy' and BLK_STS_DEV_RESOURCE is returned to block layer. In
that case the current I/O won't get a chance to get queued since it is
invisible at that time for both scsi_run_queue_async() and blk-mq's
RESTART.

Fix the issue by not returning BLK_STS_DEV_RESOURCE in this situation.

Link: https://lore.kernel.org/r/20201202100419.525144-1-ming.lei@redhat.com
Fixes: 86ff7c2a80cd ("blk-mq: introduce BLK_STS_DEV_RESOURCE")
Cc: Hannes Reinecke <hare@suse.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Long Li <longli@microsoft.com>
Reported-by: John Garry <john.garry@huawei.com>
Tested-by: "chenxiang (M)" <chenxiang66@hisilicon.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2157,8 +2157,7 @@ out_put_budget:
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
-		    scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:



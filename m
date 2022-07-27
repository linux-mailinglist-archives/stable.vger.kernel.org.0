Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11C1582DE5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiG0REr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241400AbiG0REL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:04:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D48E6E88B;
        Wed, 27 Jul 2022 09:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04F7D601CD;
        Wed, 27 Jul 2022 16:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07F6C433D6;
        Wed, 27 Jul 2022 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939931;
        bh=gwizZq9ZKJfacNy3ZHHGP30UdHE5Ee0t3vfEcqGt4H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zB3BAjhMpoh4iqi+db9Y0vkTyrVLfetLFoZcUpWDZhgh2co3cw4zpFhORQezLkIoq
         6hgWBcKw96yrzz34XesDrAoABXtiFxFiaoDodhaHpI/CCBUkx3udNmH3oz6x8byIOH
         A7nwNhKDGIjWhlPhNIZv0xsMkSmgurxMyMNQVASo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Guangwu Zhang <guazhang@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/201] scsi: megaraid: Clear READ queue maps nr_queues
Date:   Wed, 27 Jul 2022 18:09:11 +0200
Message-Id: <20220727161028.830121884@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8312cd3a7b835ae3033a679e5f0014a40e7891c5 ]

The megaraid SCSI driver sets set->nr_maps as 3 if poll_queues is > 0, and
blk-mq actually initializes each map's nr_queues as nr_hw_queues.
Consequently the driver has to clear READ queue map's nr_queues, otherwise
the queue map becomes broken if poll_queues is set as non-zero.

Link: https://lore.kernel.org/r/20220706125942.528533-1-ming.lei@redhat.com
Fixes: 9e4bec5b2a23 ("scsi: megaraid_sas: mq_poll support")
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sumit.saxena@broadcom.com
Cc: chandrakanth.patil@broadcom.com
Cc: linux-block@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Guangwu Zhang <guazhang@redhat.com>
Tested-by: Guangwu Zhang <guazhang@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index bb3f78013a13..88e164e3d2ea 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3196,6 +3196,9 @@ static int megasas_map_queues(struct Scsi_Host *shost)
 	qoff += map->nr_queues;
 	offset += map->nr_queues;
 
+	/* we never use READ queue, so can't cheat blk-mq */
+	shost->tag_set.map[HCTX_TYPE_READ].nr_queues = 0;
+
 	/* Setup Poll hctx */
 	map = &shost->tag_set.map[HCTX_TYPE_POLL];
 	map->nr_queues = instance->iopoll_q_count;
-- 
2.35.1




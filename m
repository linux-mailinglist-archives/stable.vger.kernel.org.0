Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD541579E6C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbiGSNBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243181AbiGSNAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B96761DBC;
        Tue, 19 Jul 2022 05:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7E60B81B38;
        Tue, 19 Jul 2022 12:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F4EC341CA;
        Tue, 19 Jul 2022 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233544;
        bh=chF6hNHxYwr7S/4cPwX/yypxTGcy93JoJmDViWNqhYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAlbJG5pD9aN+WSYd+L+Q8yuMv10H3ncO3q5mB6by3QQ3X015Za13QEiOHFPaCmM2
         6n1jhZWMowKecQRWXffihyHCa2eiUk1NJ7IlbjrpMApRm6yUWN2aOkw1nGM0dwLnW3
         7usj5pcZuRaahBt0DgkFBLTAKfqLO5EhNFlMgjXs=
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
Subject: [PATCH 5.18 158/231] scsi: megaraid: Clear READ queue maps nr_queues
Date:   Tue, 19 Jul 2022 13:54:03 +0200
Message-Id: <20220719114727.553269401@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index db6793608447..f5deb0e561a9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3195,6 +3195,9 @@ static int megasas_map_queues(struct Scsi_Host *shost)
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




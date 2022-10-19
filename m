Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC71603E52
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiJSJMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiJSJK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:10:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081B9C3564;
        Wed, 19 Oct 2022 02:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C85C61830;
        Wed, 19 Oct 2022 09:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3744CC433C1;
        Wed, 19 Oct 2022 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170122;
        bh=Ggo1VEe0EXDgrsvE/t2ids5mCaXNBVenLwbwOjRvDNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LUwY8y1rvtyLxQJ+Rzxyv0vLBVPcJPkX2oYoNzFb5qAiS0Kjm/fr8H4h4nT9EQld4
         ZoB/K/dXUY6voucGo0U5Nn7++b0tzaIjLFAKOyOXXY5EpzFEYMm1pojRBDvhCCkSt8
         ocm9cBfcMpd0tTevU2fTeUYNKClPBbSLFH2Ud0K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 536/862] RDMA/srp: Fix srp_abort()
Date:   Wed, 19 Oct 2022 10:30:23 +0200
Message-Id: <20221019083313.638697595@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 6dbe4a8dead84de474483910b02ec9e6a10fc1a9 ]

Fix the code for converting a SCSI command pointer into an SRP request
pointer.

Cc: Xiao Yang <yangx.jy@fujitsu.com>
Fixes: ad215aaea4f9 ("RDMA/srp: Make struct scsi_cmnd and struct srp_request adjacent")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220908233139.3042628-1-bvanassche@acm.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d7f69e593a63..9c9872868aee 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2789,7 +2789,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag, u64 lun,
 static int srp_abort(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_request *req = (struct srp_request *) scmnd->host_scribble;
+	struct srp_request *req = scsi_cmd_priv(scmnd);
 	u32 tag;
 	u16 ch_idx;
 	struct srp_rdma_ch *ch;
@@ -2797,8 +2797,6 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req)
-		return SUCCESS;
 	tag = blk_mq_unique_tag(scsi_cmd_to_rq(scmnd));
 	ch_idx = blk_mq_unique_tag_to_hwq(tag);
 	if (WARN_ON_ONCE(ch_idx >= target->ch_count))
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDB4C7345
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiB1ReU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237905AbiB1Rci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:32:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880AC8AE4E;
        Mon, 28 Feb 2022 09:29:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60CCEB815AC;
        Mon, 28 Feb 2022 17:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3E3C340E7;
        Mon, 28 Feb 2022 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069351;
        bh=yIFbtzfcZjgwqnHyMsd4GNsG3WvnonVTmaLu7gl8HkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruvA9i1gDoTuAYSeSXoxcQ/oFktzu2ELyjJTXdMAtm3uteLJHhDWSXGAIGb90oMRX
         qSpW8x+G4PfF5CdlomFDzB0vJU4t1xnwuta/uCammz/p5o6j2P3v97KvdqR5zWZ6kA
         nh5wqh8WhRZdiHAoDUTCiSLqfiIgxMAsRsUXxiyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+831661966588c802aae9@syzkaller.appspotmail.com,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/34] RDMA/ib_srp: Fix a deadlock
Date:   Mon, 28 Feb 2022 18:24:21 +0100
Message-Id: <20220228172209.678451312@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 081bdc9fe05bb23248f5effb6f811da3da4b8252 ]

Remove the flush_workqueue(system_long_wq) call since flushing
system_long_wq is deadlock-prone and since that call is redundant with a
preceding cancel_work_sync()

Link: https://lore.kernel.org/r/20220215210511.28303-3-bvanassche@acm.org
Fixes: ef6c49d87c34 ("IB/srp: Eliminate state SRP_TARGET_DEAD")
Reported-by: syzbot+831661966588c802aae9@syzkaller.appspotmail.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 03ee53adaacd2..6dcdc42ed0819 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -4154,9 +4154,11 @@ static void srp_remove_one(struct ib_device *device, void *client_data)
 		spin_unlock(&host->target_lock);
 
 		/*
-		 * Wait for tl_err and target port removal tasks.
+		 * srp_queue_remove_work() queues a call to
+		 * srp_remove_target(). The latter function cancels
+		 * target->tl_err_work so waiting for the remove works to
+		 * finish is sufficient.
 		 */
-		flush_workqueue(system_long_wq);
 		flush_workqueue(srp_remove_wq);
 
 		kfree(host);
-- 
2.34.1




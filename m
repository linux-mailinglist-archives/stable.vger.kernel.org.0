Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E91593747
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244219AbiHOTUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343877AbiHOTS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:18:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46DC3D5A8;
        Mon, 15 Aug 2022 11:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9909161124;
        Mon, 15 Aug 2022 18:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90799C433D6;
        Mon, 15 Aug 2022 18:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588785;
        bh=0r5UkRXI7xlArzqRPjOlHYSsnq34Y04hve0Lm1/L72c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0aGKtMJqrBNZcgtY1C6lTftFQFHym9aoc64LerXGrSts5HmyMxXUmIqhOfjm42BI
         7gG05j30ZsxU9tx7b0CSJiM9gQDNJKZ+ZFj+GkME+gqw810B+TPnQTatJKNDQXtTNi
         zOJcXOP7e7hwrf92YVh1XzMrNwWM7r6QwHOFfAC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cheng Xu <chengyou@linux.alibaba.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/779] RDMA/siw: Fix duplicated reported IW_CM_EVENT_CONNECT_REPLY event
Date:   Mon, 15 Aug 2022 20:02:37 +0200
Message-Id: <20220815180359.175400445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Cheng Xu <chengyou@linux.alibaba.com>

[ Upstream commit 3056fc6c32e613b760422b94c7617ac9a24a4721 ]

If siw_recv_mpa_rr returns -EAGAIN, it means that the MPA reply hasn't
been received completely, and should not report IW_CM_EVENT_CONNECT_REPLY
in this case. This may trigger a call trace in iw_cm. A simple way to
trigger this:
 server: ib_send_lat
 client: ib_send_lat -R <server_ip>

The call trace looks like this:

 kernel BUG at drivers/infiniband/core/iwcm.c:894!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 <...>
 Workqueue: iw_cm_wq cm_work_handler [iw_cm]
 Call Trace:
  <TASK>
  cm_work_handler+0x1dd/0x370 [iw_cm]
  process_one_work+0x1e2/0x3b0
  worker_thread+0x49/0x2e0
  ? rescuer_thread+0x370/0x370
  kthread+0xe5/0x110
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Link: https://lore.kernel.org/r/dae34b5fd5c2ea2bd9744812c1d2653a34a94c67.1657706960.git.chengyou@linux.alibaba.com
Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 18a64ccbb0e5..69d639cab898 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -725,11 +725,11 @@ static int siw_proc_mpareply(struct siw_cep *cep)
 	enum mpa_v2_ctrl mpa_p2p_mode = MPA_V2_RDMA_NO_RTR;
 
 	rv = siw_recv_mpa_rr(cep);
-	if (rv != -EAGAIN)
-		siw_cancel_mpatimer(cep);
 	if (rv)
 		goto out_err;
 
+	siw_cancel_mpatimer(cep);
+
 	rep = &cep->mpa.hdr;
 
 	if (__mpa_rr_revision(rep->params.bits) > MPA_REVISION_2) {
@@ -895,7 +895,8 @@ static int siw_proc_mpareply(struct siw_cep *cep)
 	}
 
 out_err:
-	siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
+	if (rv != -EAGAIN)
+		siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
 
 	return rv;
 }
-- 
2.35.1



